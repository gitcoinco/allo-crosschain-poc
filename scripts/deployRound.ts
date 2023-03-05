import { ethers } from "hardhat";

async function main() {

    // Deploy Round
    const contractFactory = await ethers.getContractFactory("Round");
    const round = await contractFactory.deploy();
    console.log(`Deploying Round to ${round.address}`);

    // Deploy Adapter
    const axelarTrustedReciever = await ethers.getContractFactory("AxelarTrustedReciever")
    const axelarRecieverContract = await axelarTrustedReciever.deploy();
    console.log(`Deploying axelarRecieverContract to ${axelarRecieverContract.address}`);

    // Link Round
    axelarRecieverContract.setRoundAddress(round.address);

    // TODO: 
    const trustedForwarder = "0x00000000"
    await round.setTrustedReciever(trustedForwarder, true);
    
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
