const { keccak256 } = require("ethereum-cryptography/keccak");
const { utf8ToBytes} = require("ethereum-cryptography/utils");  // Allows to pass string as parameter to keccak256
const { bytesToHex} = require("ethereum-cryptography/utils");  // Helps to get output from keccak256 in hexadecimal form
console.log(bytesToHex(keccak256(utf8ToBytes("Calyptus"))))