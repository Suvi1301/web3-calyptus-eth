const { scrypt } = require("ethereum-cryptography/scrypt");
const { utf8ToBytes } = require("ethereum-cryptography/utils");
const { bytesToHex} = require("ethereum-cryptography/utils");

async function getScrypt(){
    console.log( bytesToHex( await scrypt(utf8ToBytes("Calyptus"), utf8ToBytes("Hello"),1024,8,1,32)));
}
    
getScrypt();