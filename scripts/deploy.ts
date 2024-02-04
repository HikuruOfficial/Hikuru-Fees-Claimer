import { ethers } from "hardhat";

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying Hikuru FeeClaimer...");
    console.log("Deployer: ", deployer.address);

    // Deploying the contract
    const contractFactory = await ethers.getContractFactory("contracts/FeeClaimer.sol:FeeClaimer");
    const contract = await contractFactory.deploy("0x2D1CC54da76EE2aF14b289527CD026B417764fAB");
    await contract.waitForDeployment();

    console.log("Hikuru FeeClaimer contract deployed to: ", contract.target);

    return { contract, deployer };
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});

