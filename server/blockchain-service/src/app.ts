import express, { Request, Response } from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import {
    BlockfrostProvider, MeshWallet, Transaction,
    resolvePlutusScriptAddress
} from '@meshsdk/core';

// Load environment variables
dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

// Configuration
const config = {
    port: process.env.PORT || 3001,
    network: process.env.CARDANO_NETWORK || 'preprod',
    blockfrostApiKey: process.env.BLOCKFROST_API_KEY!,
    treasuryMnemonic: process.env.TREASURY_MNEMONIC!,
    treasuryAddress: process.env.TREASURY_ADDRESS!
};

// ============================================================================
// AIKEN SMART CONTRACT — Insurance Gatekeeper (Plutus V3)
// Compiled from: aiken-contracts/validators/insurance_gatekeeper.ak
// Script Hash: 5b5a1ef972750003539f76357d1c917e48b0bf5748a949a4f8adae0e
//
// The validator enforces on-chain:
//   1. Transaction MUST be signed by the treasury wallet
//   2. Datum MUST contain a non-empty hashed_user_id (Blake2b-256)
//
// NOTE: Smart contract spending is disabled due to a known MeshSDK v1 bug
//       with Plutus V3 CBOR serialization (MalformedScriptWitnesses).
//       The contract is compiled, deployed, and monitored. Payouts use the
//       treasury wallet directly. Script spending can be enabled when
//       MeshSDK v2 is released with proper Plutus V3 support.
// ============================================================================
const AIKEN_COMPILED_CODE = '59010701010029800aba2aba1aab9faab9eaab9dab9a48888896600264646644b30013370e900118031baa00189919912cc004cdc3a400060126ea80162b3001300a375400b15980099198008009bac300d300e300e300e300e300e300e300e300e300b3754601a01044b30010018a508acc004cdc79bae300e00148811c9b9460c4940fc92d01be70d036ce43f86adcff75ec043517186c5057008a518998010011807800a014403515980099b8748000c024dd5000c6600266e3cdd7180618051baa300c300a375400291100a50a51402114a08042294100845900b45900818050009805180580098039baa0018b200a30070013007300800130070013003375400f149a26cac80081';

const SCRIPT_ADDRESS = resolvePlutusScriptAddress(
    { code: AIKEN_COMPILED_CODE, version: 'V3' as const },
    config.network === 'mainnet' ? 1 : 0
);

console.log('🔧 Initializing Blockchain Service...');
console.log(`   Network: ${config.network}`);
console.log(`   Treasury: ${config.treasuryAddress.substring(0, 30)}...`);
console.log(`   📜 Smart Contract: Insurance Gatekeeper (Plutus V3)`);
console.log(`   📜 Script Address: ${SCRIPT_ADDRESS}`);

// Initialize Blockfrost provider
const provider = new BlockfrostProvider(config.blockfrostApiKey);

// Initialize Treasury wallet with MeshSDK
let wallet: MeshWallet;
try {
    wallet = new MeshWallet({
        networkId: config.network === 'mainnet' ? 1 : 0,
        fetcher: provider,
        submitter: provider,
        key: {
            type: 'mnemonic',
            words: config.treasuryMnemonic.trim().split(/\s+/)
        }
    });
    console.log('✅ Treasury wallet initialized');
} catch (error) {
    console.error('❌ Failed to initialize wallet:', error);
    process.exit(1);
}

// Helper: wrap any promise with a timeout so MeshSDK can't hang forever
const withTimeout = <T>(promise: Promise<T>, ms: number, label: string): Promise<T> => {
    return Promise.race([
        promise,
        new Promise<T>((_, reject) =>
            setTimeout(() => reject(new Error(`${label} timed out after ${ms / 1000}s`)), ms)
        )
    ]);
};

// ============================================================================
// Fetch UTXOs at the script address via Blockfrost (for balance monitoring)
// ============================================================================
async function getScriptUtxos() {
    const baseUrl = `https://cardano-${config.network}.blockfrost.io/api/v0`;
    const headers = { 'project_id': config.blockfrostApiKey };

    const response = await fetch(`${baseUrl}/addresses/${SCRIPT_ADDRESS}/utxos`, { headers });
    if (!response.ok) {
        if (response.status === 404) return []; // No UTXOs yet
        throw new Error(`Blockfrost error: ${response.status}`);
    }

    const utxos = await response.json() as any[];

    // Convert Blockfrost format to MeshSDK UTxO format
    return utxos.map((u: any) => ({
        input: {
            txHash: u.tx_hash,
            outputIndex: u.tx_index
        },
        output: {
            address: SCRIPT_ADDRESS,
            amount: u.amount.map((a: any) => ({
                unit: a.unit,
                quantity: a.quantity
            })),
            dataHash: u.data_hash || undefined,
            plutusData: u.inline_datum || undefined
        }
    }));
}

// Calculate total lovelace in a set of UTXOs
function totalLovelace(utxos: any[]): number {
    let total = 0;
    for (const utxo of utxos) {
        for (const asset of utxo.output.amount) {
            if (asset.unit === 'lovelace') {
                total += parseInt(asset.quantity);
            }
        }
    }
    return total;
}

// ============================================================================
// ENDPOINT 1: Health Check
// ============================================================================
app.get('/health', async (req: Request, res: Response) => {
    try {
        const walletAddress = wallet.getChangeAddress();
        const walletUtxos = await wallet.getUtxos();
        const scriptUtxos = await getScriptUtxos();

        const walletLovelace = totalLovelace(walletUtxos);
        const scriptLovelace = totalLovelace(scriptUtxos);

        res.json({
            status: 'healthy',
            network: config.network,
            smartContract: {
                address: SCRIPT_ADDRESS,
                balanceADA: (scriptLovelace / 1_000_000).toFixed(2),
                utxoCount: scriptUtxos.length,
                validator: 'Insurance Gatekeeper (Plutus V3)'
            },
            treasuryWallet: {
                address: walletAddress,
                balanceADA: (walletLovelace / 1_000_000).toFixed(2),
                utxoCount: walletUtxos.length
            },
            totalBalanceADA: ((walletLovelace + scriptLovelace) / 1_000_000).toFixed(2)
        });
    } catch (error: any) {
        res.status(500).json({
            status: 'error',
            error: error.message
        });
    }
});

// ============================================================================
// ENDPOINT: Submit Payout Transaction
// Treasury wallet sends ADA directly to the recipient.
// On-chain metadata ties each payout to the ML-approved claim.
// ============================================================================
interface PayoutRequest {
    recipientAddress: string;
    amountLovelace: number;
    hashedUserId?: string;
    claimMetadata: {
        claim_id: number;
        user_id: number;
        amount: number;
        amount_usd?: number;
        amount_ada?: number;
        ml_status: string;
        claim_type: string;
        patient_name?: string;
    };
}

app.post('/api/payout-transaction', async (req: Request, res: Response) => {
    const { recipientAddress, amountLovelace, hashedUserId, claimMetadata } = req.body as PayoutRequest;

    try {
        if (!recipientAddress || !amountLovelace || !claimMetadata) {
            return res.status(400).json({
                success: false,
                error: 'Missing required fields: recipientAddress, amountLovelace, claimMetadata'
            });
        }

        if (amountLovelace < 1_000_000) {
            return res.status(400).json({
                success: false,
                error: 'Minimum payout is 1 ADA (1,000,000 lovelace)'
            });
        }

        console.log(`\n📤 Processing payout...`);
        console.log(`   Recipient: ${recipientAddress}`);
        console.log(`   Amount: ${amountLovelace} lovelace (${(amountLovelace / 1_000_000).toFixed(2)} ADA)`);
        console.log(`   Claim ID: ${claimMetadata.claim_id}`);

        const utxos = await withTimeout(wallet.getUtxos(), 30000, 'getUtxos');
        console.log(`   Found ${utxos.length} wallet UTXOs`);

        const tx = new Transaction({ initiator: wallet });
        tx.sendLovelace(recipientAddress, amountLovelace.toString());

        // Attach claim metadata on-chain (label 674 = CIP-20 transaction message)
        tx.setMetadata(674, {
            msg: ['HealthTrust Insurance Payout'],
            claim_id: claimMetadata.claim_id,
            user_id: claimMetadata.user_id,
            amount_usd: claimMetadata.amount_usd || claimMetadata.amount,
            amount_ada: claimMetadata.amount_ada || claimMetadata.amount,
            ml_status: claimMetadata.ml_status,
            claim_type: claimMetadata.claim_type,
            patient: claimMetadata.patient_name || 'N/A',
            hashed_user_id: hashedUserId || 'N/A',
            smart_contract: SCRIPT_ADDRESS,
            approved_at: new Date().toISOString(),
            network: config.network
        });

        console.log('   Building transaction...');
        const unsignedTx = await withTimeout(tx.build(), 60000, 'tx.build');

        console.log('   Signing with treasury key...');
        const signedTx = await withTimeout(wallet.signTx(unsignedTx), 15000, 'signTx');

        console.log('   Submitting to Cardano network...');
        const txHash = await withTimeout(wallet.submitTx(signedTx), 60000, 'submitTx');

        const explorerUrl = `https://${config.network}.cardanoscan.io/transaction/${txHash}`;

        console.log(`✅ Payout submitted!`);
        console.log(`   TX Hash: ${txHash}`);
        console.log(`   Explorer: ${explorerUrl}`);

        res.json({
            success: true,
            txHash,
            explorerUrl,
            network: config.network,
            timestamp: new Date().toISOString()
        });

    } catch (error: any) {
        console.error('❌ Payout error:', error.message);
        res.status(500).json({
            success: false,
            error: error.message || 'Transaction failed'
        });
    }
});

// ============================================================================
// ENDPOINT: Get Transaction Details
// ============================================================================
app.get('/api/transaction/:txHash', async (req: Request, res: Response) => {
    const { txHash } = req.params;

    console.log(`\n🔍 Fetching transaction details: ${txHash}`);

    try {
        const baseUrl = `https://cardano-${config.network}.blockfrost.io/api/v0`;
        const headers = { 'project_id': config.blockfrostApiKey };

        // Fetch transaction data from Blockfrost
        const [txResponse, metadataResponse, utxosResponse, latestBlockResponse] = await Promise.all([
            fetch(`${baseUrl}/txs/${txHash}`, { headers }),
            fetch(`${baseUrl}/txs/${txHash}/metadata`, { headers }),
            fetch(`${baseUrl}/txs/${txHash}/utxos`, { headers }),
            fetch(`${baseUrl}/blocks/latest`, { headers })
        ]);

        if (!txResponse.ok) {
            return res.status(404).json({
                success: false,
                error: 'Transaction not found'
            });
        }

        const txData = await txResponse.json() as any;
        const metadataArray = await metadataResponse.json() as any[];
        const utxos = await utxosResponse.json() as any;
        const latestBlock = await latestBlockResponse.json() as any;

        // Calculate confirmations
        const confirmations = latestBlock.slot - txData.slot;

        // Extract metadata label 674
        const claimMetadata = metadataArray.find((m: any) => m.label === '674');

        const result = {
            txHash: txData.hash,
            blockHeight: txData.block_height,
            blockHash: txData.block,
            blockTimestamp: new Date(txData.block_time * 1000).toISOString(),
            slot: txData.slot,
            confirmations,
            size: txData.size,
            fees: txData.fees,
            totalOutput: txData.output_amount.find((a: any) => a.unit === 'lovelace')?.quantity || '0',
            metadata: claimMetadata?.json_metadata || {},
            inputs: utxos.inputs,
            outputs: utxos.outputs,
            status: confirmations > 0 ? 'confirmed' : 'pending',
            network: config.network,
            explorerUrl: `https://${config.network}.cardanoscan.io/transaction/${txHash}`
        };

        console.log(`✅ Transaction found: ${confirmations} confirmations`);

        res.json(result);

    } catch (error: any) {
        console.error('❌ Error fetching transaction:', error.message);
        res.status(500).json({
            success: false,
            error: error.message || 'Failed to fetch transaction'
        });
    }
});

// ============================================================================
// ENDPOINT: Get Balance (wallet + smart contract monitoring)
// ============================================================================
app.get('/api/balance', async (req: Request, res: Response) => {
    try {
        const walletUtxos = await wallet.getUtxos();
        const scriptUtxos = await getScriptUtxos();

        const walletLovelace = totalLovelace(walletUtxos);
        const scriptLovelace = totalLovelace(scriptUtxos);

        res.json({
            wallet: {
                address: wallet.getChangeAddress(),
                balanceADA: (walletLovelace / 1_000_000).toFixed(2),
                balanceLovelace: walletLovelace,
                utxoCount: walletUtxos.length
            },
            smartContract: {
                address: SCRIPT_ADDRESS,
                balanceADA: (scriptLovelace / 1_000_000).toFixed(2),
                balanceLovelace: scriptLovelace,
                utxoCount: scriptUtxos.length
            },
            totalBalanceADA: ((walletLovelace + scriptLovelace) / 1_000_000).toFixed(2)
        });
    } catch (error: any) {
        res.status(500).json({
            success: false,
            error: error.message
        });
    }
});

// ============================================================================
// ENDPOINT: Epoch and Network Info (used by frontend)
// ============================================================================
app.get('/api/epoch', async (req: Request, res: Response) => {
    try {
        const baseUrl = `https://cardano-${config.network}.blockfrost.io/api/v0`;
        const headers = { 'project_id': config.blockfrostApiKey };

        const [epochResponse, blockResponse] = await Promise.all([
            fetch(`${baseUrl}/epochs/latest`, { headers }),
            fetch(`${baseUrl}/blocks/latest`, { headers })
        ]);

        const epoch = await epochResponse.json() as any;
        const block = await blockResponse.json() as any;

        res.json({
            epoch: epoch.epoch,
            slot: block.slot,
            block_height: block.height,
            block_time: block.time,
            network: config.network
        });
    } catch (error: any) {
        res.status(500).json({ success: false, error: error.message });
    }
});

// Start server
const port = Number(config.port);
app.listen(port, '127.0.0.1', () => {
    console.log('\n' + '='.repeat(60));
    console.log('🚀 Blockchain Service Started Successfully!');
    console.log('='.repeat(60));
    console.log(`📡 Server: http://127.0.0.1:${config.port}`);
    console.log(`🌐 Network: ${config.network.toUpperCase()}`);
    console.log(`💰 Treasury: ${config.treasuryAddress}`);
    console.log(`📜 Script:   ${SCRIPT_ADDRESS}`);
    console.log('='.repeat(60));
    console.log('\nEndpoints:');
    console.log(`  GET  /health                     - Service health + balances`);
    console.log(`  GET  /api/balance                - Wallet + script balance`);
    console.log(`  POST /api/payout-transaction     - Payout to recipient`);
    console.log(`  GET  /api/transaction/:txHash    - Transaction details`);
    console.log('='.repeat(60) + '\n');
});
