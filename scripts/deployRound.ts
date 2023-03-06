import { ethers } from "hardhat";

async function main() {

    // Deploy Round
    const contractFactory = await ethers.getContractFactory("Round");
    const round = await contractFactory.deploy();
    console.log(`Deploying Round to ${round.address}`);    
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
