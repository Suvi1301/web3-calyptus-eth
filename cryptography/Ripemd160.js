const { ripemd160 } = require("ethereum-cryptography/ripemd160");
const { utf8ToBytes} = require("ethereum-cryptography/utils");  // Allows to pass string as parameter to ripemd160
const { bytesToHex} = require("ethereum-cryptography/utils");  // Helps to get output from ripemd160 in hexadecimal form
console.log(bytesToHex(ripemd160(utf8ToBytes("Calyptus"))))