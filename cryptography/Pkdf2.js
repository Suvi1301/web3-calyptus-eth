const { pbkdf2 } = require("ethereum-cryptography/pbkdf2");
const { utf8ToBytes } = require("ethereum-cryptography/utils");

const { bytesToHex} = require("ethereum-cryptography/utils");

async function getPbkdf2(){
    console.log( bytesToHex( await pbkdf2(utf8ToBytes("Calyptus"), utf8ToBytes("Hello"), 999, 32, "sha256")));
}
getPbkdf2();