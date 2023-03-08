import { ethers } from "hardhat";

async function main() {
  const network = await ethers.provider.getNetwork();
  const networkName = await hre.network.name;
  const account = (await ethers.getSigners())[0];

  console.log(`chainId: ${network.chainId}`);
  console.log(`network: ${networkName} (from ethers: ${network.name})`);
  console.log(`account: ${account.address}`);

  const Registry = await ethers.getContractFactory("Registry", account);
  const registry = await Registry.deploy();
  console.log("registry deployed at", registry.address);

  const AxelarApplicationForwarder = await ethers.getContractFactory(
    "AxelarApplicationForwarder",
    account
  );

  const gatewayAddress = "0xe432150cce91c13a887f7D836923d5597adD8E31";
  const gasReceiverAddress = "0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6";
  const destinationAddress = "0xCA3597cDe46f9e932D187ec66A5f12B5CE235a81";

  const forwarder = await AxelarApplicationForwarder.deploy(
    registry.address,
    gatewayAddress,
    gasReceiverAddress
  );
  console.log("forwarder deployed at", forwarder.address);

  console.log("updating forwarders...");
  await registry.updateForwarder(forwarder.address, true);
  console.log("done.");

  console.log("creating first project...");
  await registry.createProject();
  console.log("done.");

  console.log("creating second project...");
  const tx = await registry.createProject();
  console.log("done.");
  const rec = await tx.wait();
  const projectID = rec.logs[0].data;
  console.log("projectID", projectID);

  console.log("applyToRound...");
  await registry.applyToRound(
    forwarder.address,
    {
      projectID: projectID,
      destinationChain: "Fantom",
      destinationAddress,
      value: projectID,
    },
    { value: ethers.utils.parseEther("0.1") }
  );
  console.log("done.");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
