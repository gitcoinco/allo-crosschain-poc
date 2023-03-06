import { ethers } from "hardhat";

async function main() {

    const roundContract = "";
    const round= await ethers.getContractAt("Round", roundContract);
    
    const axelarTrustedReceiverContract = "";
    const axelarTrustedReceiver = await ethers.getContract("AxelarTrustedReceiver", axelarTrustedReceiverContract);
    
    await round.setTrustedReceiver(axelarTrustedReceiver.address);

    await axelarTrustedReceiver.init(round.address, ethers.constants.AddressZero);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});