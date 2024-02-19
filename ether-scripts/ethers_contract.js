const { ethers } = require("ethers");

const sender_pvt_key = ""; // Private key here

let provider = ethers.getDefaultProvider("sepolia");
let sender_wallet = new ethers.Wallet(sender_pvt_key, provider);

const contract_address = "0xD520b69C70e892757439837eB704f57595886d87";
const contract_ABI = [{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[],"name":"decrement","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"increment","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"variable","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"}]

const contract = new ethers.Contract(contract_address, contract_ABI, provider);

async function interact() {
    const value = await contract.variable();
    console.log(value);
    const contractWithSigner = contract.connect(sender_wallet);
    const tx = await contractWithSigner.decrement();
    await tx.wait();
    console.log("Tx hash: ", tx.hash);
    const newValue = await contract.variable();
    console.log("Current value: ", newValue);
};
interact();


