import express, { Request, Response } from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { BlockfrostProvider, MeshWallet, Transaction } from '@meshsdk/core';

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

console.log('🔧 Initializing Blockchain Service...');
console.log(`   Network: ${config.network}`);
console.log(`   Treasury: ${config.treasuryAddress.substring(0, 20)}...`);

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

// ============================================================================
// ENDPOINT 1: Health Check
// ============================================================================
app.get('/health', async (req: Request, res: Response) => {
    try {
        const walletAddress = wallet.getChangeAddress();
        const utxos = await wallet.getUtxos();

        // Calculate total balance
        let totalLovelace = 0;
        utxos.forEach(utxo => {
            utxo.output.amount.forEach(asset => {
                if (asset.unit === 'lovelace') {
                    totalLovelace += parseInt(asset.quantity);
                }
            });
        });

        res.json({
            status: 'healthy',
            network: config.network,
            treasuryAddress: walletAddress,
            balanceADA: (totalLovelace / 1_000_000).toFixed(2),
            balanceLovelace: totalLovelace,
            utxoCount: utxos.length
        });
    } catch (error: any) {
        res.status(500).json({
            status: 'error',
            error: error.message
        });
    }
});

// ============================================================================
// ENDPOINT 2: Submit Payout Transaction
// ============================================================================
interface PayoutRequest {
    recipientAddress: string;
    amountLovelace: number;
    claimMetadata: {
        claim_id: number;
        user_id: number;
        amount: number;
        ml_status: string;
        claim_type: string;
        patient_name?: string;
    };
}

app.post('/api/payout-transaction', async (req: Request, res: Response) => {
    const { recipientAddress, amountLovelace, claimMetadata } = req.body as PayoutRequest;

    console.log(`\n📤 Processing payout transaction...`);
    console.log(`   Recipient: ${recipientAddress}`);
    console.log(`   Amount: ${amountLovelace} lovelace (${(amountLovelace / 1_000_000).toFixed(2)} ADA)`);
    console.log(`   Claim ID: ${claimMetadata.claim_id}`);

    try {
        // Validate inputs
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

        // Build transaction
        const tx = new Transaction({ initiator: wallet });

        // Add output (send ADA to recipient)
        tx.sendLovelace(recipientAddress, amountLovelace.toString());

        // Attach claim metadata (label 674 - custom application data)
        tx.setMetadata(674, {
            claim_id: claimMetadata.claim_id,
            user_id: claimMetadata.user_id,
            amount: claimMetadata.amount,
            ml_status: claimMetadata.ml_status,
            claim_type: claimMetadata.claim_type,
            patient_name: claimMetadata.patient_name || 'N/A',
            approved_at: new Date().toISOString(),
            network: config.network
        });

        console.log('   Building transaction...');
        const unsignedTx = await tx.build();

        console.log('   Signing transaction...');
        const signedTx = await wallet.signTx(unsignedTx);

        console.log('   Submitting to Cardano network...');
        const txHash = await wallet.submitTx(signedTx);

        const explorerUrl = `https://${config.network}.cardanoscan.io/transaction/${txHash}`;

        console.log(`✅ Transaction submitted successfully!`);
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
        console.error('❌ Transaction error:', error.message);
        res.status(500).json({
            success: false,
            error: error.message || 'Transaction failed'
        });
    }
});

// ============================================================================
// ENDPOINT 3: Get Transaction Details
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
// ENDPOINT 4: Get Wallet Balance
// ============================================================================
app.get('/api/balance', async (req: Request, res: Response) => {
    try {
        const utxos = await wallet.getUtxos();

        let totalLovelace = 0;
        utxos.forEach(utxo => {
            utxo.output.amount.forEach(asset => {
                if (asset.unit === 'lovelace') {
                    totalLovelace += parseInt(asset.quantity);
                }
            });
        });

        res.json({
            address: wallet.getChangeAddress(),
            balanceADA: (totalLovelace / 1_000_000).toFixed(2),
            balanceLovelace: totalLovelace,
            utxoCount: utxos.length
        });
    } catch (error: any) {
        res.status(500).json({
            success: false,
            error: error.message
        });
    }
});

// Start server
app.listen(config.port, () => {
    console.log('\n' + '='.repeat(60));
    console.log('🚀 Blockchain Service Started Successfully!');
    console.log('='.repeat(60));
    console.log(`📡 Server: http://localhost:${config.port}`);
    console.log(`🌐 Network: ${config.network.toUpperCase()}`);
    console.log(`💰 Treasury: ${config.treasuryAddress}`);
    console.log('='.repeat(60));
    console.log('\nEndpoints:');
    console.log(`  GET  /health                        - Service health check`);
    console.log(`  GET  /api/balance                   - Treasury balance`);
    console.log(`  POST /api/payout-transaction        - Submit payout`);
    console.log(`  GET  /api/transaction/:txHash       - Get transaction details`);
    console.log('='.repeat(60) + '\n');
});
