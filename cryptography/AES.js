const { encrypt ,decrypt} = require("ethereum-cryptography/aes");
const { hexToBytes,bytesToHex,utf8ToBytes, bytesToUtf8} =require("ethereum-cryptography/utils");

async  function AESEnc(){
    console.log("Result after AES Encryption",
    bytesToHex(await encrypt(
        utf8ToBytes("Calyptus"),
        hexToBytes("2b7e151628aed2a6abf7158809cf4f3c"),
        hexToBytes("f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff")
        )
    ));
}

async function AESDec(){
    console.log("Result after AES  Decryption",
        bytesToUtf8(await decrypt(
            await encrypt(
                utf8ToBytes("Calyptus"),
                hexToBytes("2b7e151628aed2a6abf7158809cf4f3c"),
                hexToBytes("f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff")
            ),
            hexToBytes("2b7e151628aed2a6abf7158809cf4f3c"),
            hexToBytes("f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff")
            )
        )
    );
}
AESEnc()
AESDec()