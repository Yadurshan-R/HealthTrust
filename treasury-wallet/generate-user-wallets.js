#!/usr/bin/env node

import { MeshWallet, BlockfrostProvider } from '@meshsdk/core';
import * as fs from 'fs';
import * as path from 'path';

console.log('👥 Creating Test User Wallets for Insurance dApp');
console.log('='.repeat(60));
console.log('');

const users = [
    { id: 1, name: 'Alice Johnson', email: 'alice@example.com' },
    { id: 2, name: 'Bob Smith', email: 'bob@example.com' },
    { id: 3, name: 'Carol Williams', email: 'carol@example.com' }
];

const results = [];

for (const user of users) {
    console.log(`\n📝 Generating wallet for: ${user.name}`);
    console.log('-'.repeat(60));

    // Generate mnemonic
    const mnemonic = MeshWallet.brew();

    // Create wallet
    const wallet = new MeshWallet({
        networkId: 0, // Preprod
        fetcher: new BlockfrostProvider('preprodHeO1e9abeJx2hfKcP8gS9y6y1PhhibL0'),
        submitter: new BlockfrostProvider('preprodHeO1e9abeJx2hfKcP8gS9y6y1PhhibL0'),
        key: {
            type: 'mnemonic',
            words: mnemonic,
        },
    });

    const address = wallet.getChangeAddress();

    console.log(`Address: ${address}`);

    // Save to file
    const userDir = path.join(process.cwd(), 'users', user.name.replace(' ', '_').toLowerCase());
    fs.mkdirSync(userDir, { recursive: true });

    fs.writeFileSync(
        path.join(userDir, 'mnemonic.txt'),
        mnemonic.join(' ')
    );

    fs.writeFileSync(
        path.join(userDir, 'address.txt'),
        address
    );

    results.push({
        userId: user.id,
        name: user.name,
        email: user.email,
        address: address,
        mnemonic: mnemonic.join(' ')
    });
}

console.log('\n\n✅ All User Wallets Generated!');
console.log('='.repeat(60));
console.log('');

// Generate SQL update script
let sqlScript = '-- Update user wallet addresses\n\n';
for (const user of results) {
    sqlScript += `UPDATE users SET wallet_address = '${user.address}' WHERE id = ${user.userId};\n`;
}

fs.writeFileSync(
    path.join(process.cwd(), 'update_user_wallets.sql'),
    sqlScript
);

console.log('📋 Summary:');
console.log('='.repeat(60));
results.forEach(user => {
    console.log(`\n${user.name}:`);
    console.log(`  ID: ${user.userId}`);
    console.log(`  Address: ${user.address}`);
    console.log(`  Mnemonic saved: users/${user.name.replace(' ', '_').toLowerCase()}/mnemonic.txt`);
});

console.log('\n\n📝 SQL Update Script Generated:');
console.log('   File: update_user_wallets.sql');
console.log('');
console.log('🚀 Next Steps:');
console.log('='.repeat(60));
console.log('1. Run the SQL script to update database:');
console.log('   sudo -u postgres psql HealthTrust < treasury-wallet/update_user_wallets.sql');
console.log('');
console.log('2. Users can now receive payouts at their wallet addresses!');
console.log('='.repeat(60));
