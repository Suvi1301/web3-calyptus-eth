const hre = require("hardhat");
const ethers = hre.ethers;

const MyContractABI = require("../artifacts/contracts/MyContract.sol/MyContract.json");
const MyContractAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";

async function main() {
    const signers = await ethers.getSigners();
    const account = await ethers.getSigner("0x70997970C51812dc3A010C7d01b50e0d17dc79C8"); // get specific signer
    
    const MyContract = await ethers.getContractAtFromArtifact(
        MyContractABI,
        MyContractAddress
    );

    try {
        // fetching intial value of num
        var num = await MyContract.getNum();
        console.log("Initial value of num is " + num.toString());

        // incerementing num using first (default) account
        var txInc = await MyContract.increment();
        await txInc.wait();
        console.log("Num has been incremented by first account");

        // fetching new value of num
        num = await MyContract.getNum();
        console.log("Incremented value of num is " + num.toString());

        // decrementing num using second(connected) account
        var txDec = await MyContract.connect(account).decrement();
        await txDec.wait();
        console.log("Num has been decremented by second account");

        // fetching new value of num
        num = MyContract.getNum();
        console.log("Decremented value of num is " + num.toString());
    } catch (error) {
        console.log(error);
    }
}

main();