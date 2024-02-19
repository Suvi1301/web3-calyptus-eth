const { getRandomBytes} = require("ethereum-cryptography/random");
const { bytesToHex} = require("ethereum-cryptography/utils");

async function getCSPRN() {
    console.log(bytesToHex(await getRandomBytes(32)));
}

getCSPRN();