require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");
require("@openzeppelin/hardhat-upgrades");
require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

const MAINNET_RPC_URL = process.env.MAINNET_RPC_URL;
const GOERLI_RPC_URL = process.env.GOERLI_RPC_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const ETHERSCAN_API = process.env.ETHERSCAN_API;

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();
  const provider = hre.ethers.provider;

  for (const account of accounts) {
    console.log(
      "%s (%i ETH)",
      account.address,
      hre.ethers.utils.formatEther(
        // getBalance returns wei amount, format to ETH amount
        await provider.getBalance(account.address)
      )
    );
  }
});

module.exports = {
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        runs: 600,
      },
    },
  },
  networks: {
    goerli: {
      url: GOERLI_RPC_URL,
      accounts: [PRIVATE_KEY],
    },
    mainnet: {
      url: MAINNET_RPC_URL,
      accounts: [PRIVATE_KEY],
    },
    hardhat: {
      accounts: {
        count: 1000,
      },
    },
  },

  etherscan: {
    apiKey: {
      goerli: ETHERSCAN_API,
      mainnet: ETHERSCAN_API,
    },
  },
};
