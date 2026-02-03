const { AppWallet } = require('@meshsdk/core');

const mnemonic = 'decrease motion virus whip dentist during island decline resource size quiz veteran swallow tower blind early stereo door choose enroll fly depart cost note';

async function generateWallet() {
    try {
        const wallet = new AppWallet({
            networkId: 0, // Preprod testnet
            fetcher: null,
            submitter: null,
            key: {
                type: 'mnemonic',
                words: mnemonic.split(' ')
            }
        });

        const address = await wallet.getPaymentAddress();

        console.log('\n=== ALICE\'S NEW WALLET ===');
        console.log('Mnemonic:', mnemonic);
        console.log('Address:', address);
        console.log('Network: Preprod Testnet');
        console.log('============================\n');
    } catch (error) {
        console.error('Error:', error.message);
    }
}

generateWallet();
