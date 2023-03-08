import { HardhatUserConfig } from "hardhat/config";
// import "@nomicfoundation/hardhat-toolbox";
import "@nomiclabs/hardhat-ethers";

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  networks: {
    goerli: {
      url: `https://eth-goerli.alchemyapi.io/v2/${process.env["ALCHEMY_KEY_GOERLI"]}`,
      accounts: {
        mnemonic: process.env.TEST_MNEMONIC,
      },
    },
  },
};

export default config;
