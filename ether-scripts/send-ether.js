const { ethers } = require("ethers");

const sender_pvt_key = ""; // Private key here
const receiver_address = "0x5880A28fF163991aac06E15CF5D92eadbaDAd83f";
const amount = "0.05";

let provider = ethers.getDefaultProvider("sepolia");

let sender_wallet = new ethers.Wallet(sender_pvt_key, provider);

// console.log(sender_wallet.address);

// Create a transaction object with "to (receiver add)" and amount to send

let tx = {
    to: receiver_address,
    value: ethers.parseEther(amount),
};

sender_wallet.sendTransaction(tx).then((result) => {
    console.log("txHash", result.hash);
});