#!/usr/bin/env node

import { MeshWallet, BlockfrostProvider } from '@meshsdk/core';
import * as fs from 'fs';
import * as path from 'path';

console.log('🔐 Cardano Treasury Wallet Generator (Preprod Testnet)');
console.log('='.repeat(60));
console.log('');

// Generate new mnemonic (24 words)
const mnemonic = MeshWallet.brew();

console.log('📝 Generated 24-word Mnemonic (SAVE THIS SECURELY!):');
console.log('='.repeat(60));
console.log(mnemonic.join(' '));
console.log('='.repeat(60));
console.log('');
console.log('⚠️  WARNING: Store this mnemonic safely! You need it to access funds.');
console.log('');

// Create wallet from mnemonic
const wallet = new MeshWallet({
    networkId: 0, // 0 = Preprod testnet, 1 = Mainnet
    fetcher: new BlockfrostProvider('preprodHeO1e9abeJx2hfKcP8gS9y6y1PhhibL0'),
    submitter: new BlockfrostProvider('preprodHeO1e9abeJx2hfKcP8gS9y6y1PhhibL0'),
    key: {
        type: 'mnemonic',
        words: mnemonic,
    },
});

// Get wallet address
const address = wallet.getChangeAddress();
console.log('💰 Treasury Wallet Address (Preprod):');
console.log('='.repeat(60));
console.log(address);
console.log('='.repeat(60));
console.log('');

// Save to files
const outputDir = path.resolve(process.cwd());

// Save mnemonic
fs.writeFileSync(
    path.join(outputDir, 'treasury.mnemonic'),
    mnemonic.join(' ')
);
console.log('✅ Saved mnemonic to: treasury.mnemonic');

// Save address
fs.writeFileSync(
    path.join(outputDir, 'treasury.addr'),
    address
);
console.log('✅ Saved address to: treasury.addr');

// Update .env file
const envPath = path.join(outputDir, '..', '.env');
let envContent = fs.readFileSync(envPath, 'utf8');

// Update TREASURY_ADDRESS
envContent = envContent.replace(
    /TREASURY_ADDRESS=.*/,
    `TREASURY_ADDRESS=${address}`
);

// Add TREASURY_MNEMONIC if not exists
if (!envContent.includes('TREASURY_MNEMONIC')) {
    envContent += `\nTREASURY_MNEMONIC=${mnemonic.join(' ')}\n`;
} else {
    envContent = envContent.replace(
        /TREASURY_MNEMONIC=.*/,
        `TREASURY_MNEMONIC=${mnemonic.join(' ')}`
    );
}

fs.writeFileSync(envPath, envContent);
console.log('✅ Updated ../.env with treasury details');
console.log('');

console.log('📋 Next Steps:');
console.log('='.repeat(60));
console.log('1. Send test tADA to this address from your Lace wallet:');
console.log(`   ${address}`);
console.log('');
console.log('2. Visit Cardano faucet (if needed):');
console.log('   https://docs.cardano.org/cardano-testnets/tools/faucet/');
console.log('');
console.log('3. Verify on Preprod explorer:');
console.log(`   https://preprod.cardanoscan.io/address/${address}`);
console.log('');
console.log('4. Once funded, restart the Go automation service');
console.log('='.repeat(60));
