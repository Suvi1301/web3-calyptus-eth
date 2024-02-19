const { blake2b } = require("ethereum-cryptography/blake2b");
const { utf8ToBytes} = require("ethereum-cryptography/utils");  // Allows to pass string as parameter to blake2b
const { bytesToHex} = require("ethereum-cryptography/utils");  // Helps to get output from blake2b in hexadecimal form
console.log(bytesToHex(blake2b(utf8ToBytes("Calyptus"))))