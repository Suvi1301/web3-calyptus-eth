const { sha256 } = require("ethereum-cryptography/sha256");
const { utf8ToBytes } = require("ethereum-cryptography/utils");  // Allows to pass string as parameter to SHA256
const { bytesToHex } = require("ethereum-cryptography/utils");  // Helps to get output from SHA256 in hexadecimal form
console.log(bytesToHex (sha256(utf8ToBytes("Calyptus"))))