const secp256k1 = require("ethereum-cryptography/secp256k1");

(async () => {
    // You pass either a hex string, or Uint8Array
    const privateKey = "f310db9d294b47aa6f395b55b585343b519ac77878d32b63f020239f0321f0bb";
    const messageHash = "e25bb8f8f0d1598b5f25853f92813cbae8fcab2848c3135e244e796ccfc7edd8";
    const publicKey = secp256k1.getPublicKey(privateKey);
    const signature = await secp256k1.sign(messageHash, privateKey);
    const verified = secp256k1.verify(signature, messageHash, publicKey);
    console.log("Verified",verified);
    
})();