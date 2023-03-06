import { ethers } from "hardhat";

async function main() {

    // Deploy Trusted Reciever
    const gateway = "0x97837985Ec0494E7b9C71f5D3f9250188477ae14"; // fantom

    const contractFactory = await ethers.getContractFactory("AxelarTrustedReciever")
    const contract = await contractFactory.deploy(gateway);
    console.log(`Deploying axelarRecieverContract to ${contract.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
