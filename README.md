# PandoraNFT
[![Open Source Love](https://badges.frapsoft.com/os/v2/open-source.svg?v=103)](https://github.com/ellerbrock/open-source-badges/)
[![Solidity Version](https://img.shields.io/badge/solidity-0.8.17-blueviolet)](https://solidity.readthedocs.io/en/v0.8.17/) 
[![TypeScript](https://badges.frapsoft.com/typescript/code/typescript.svg?v=101)](https://github.com/ellerbrock/typescript-badges/)


This repository contains the code for the PandoraNFT smart contract. The smart contract is an ERC-721 standard Non-Fungible Token (NFT) that is used to represent unique assets within the Pandora ecosystem.  This smart contract has been built with security and decentralization in mind and allows users to mint, transfer and manage their collectible items securely.

##  🧭 Table of Contents
- [PandoraNFT](#pandoranft)
  - [🧭 Table of Contents](#-table-of-contents)
  - [👋 Introduction](#-introduction)
  - [✨️ Features](#️-features)
  - [📜 Requirements](#-requirements)
  - [⚙️ Installation and Deployment](#️-installation-and-deployment)
  - [🚀 Test](#-test)
  - [🔧 Usage](#-usage)
  - [✅ Verified Smart Contract](#-verified-smart-contract)
  - [👥 Contributing](#-contributing)
  - [🔓 License](#-license)

## 👋 Introduction

PandoraNFT is an open-source, flexible and scalable smart contract for creating and managing NFTs on the Ethereum blockchain. It is designed to handle all the important aspects of NFTs including creation, transfer, and ownership, with easy to use functions.

## ✨️ Features

- Decentralized ownership: Users have full control over their NFTs, and all transactions are executed on the Ethereum blockchain.
- Whitelisting: The contract allows the owner to specify a whitelist of addresses that are authorized to mint NFTs.
- Admin control: The contract owner can specify the state of minting and determine which type of minting should be active (Team, Airdrop, Whitelist, Public).
- Transferable: NFTs can be transferred from one address to another, allowing for a thriving NFT market.
- Upgradability: The contract implements the Proxy Contract Upgradeability pattern, allowing for easy and safe upgrades to the contract logic without affecting the contract address or altering the existing NFTs.


## 📜 Requirements

- [Node.js](https://nodejs.org/en/)
- [NPM](https://www.npmjs.com/)
- [Hardhat](https://hardhat.org/)

## ⚙️ Installation and Deployment

1. Clone this repository
   
```shell
git clone https://github.com/alex-necsoiu/pandora-nft
```

2. Install the Dependencies and Dotenv

```shell
npm install
yarn install
```

3. Create .env file

```shell
GOERLI_RPC_URL = 
MAINNET_RPC_URL= 
PRIVATE_KEY = 
ETHERSCAN_API = 
INFURA_KEY=
```

4. Compiling the Smart Contracts

```shell
npx hardhat clean
npx hardhat compile
```


5. Deploying to a Network

To deploy the contract to a network such as Ethereum mainnet, modify the deployment script (scripts/deploy.js) and run the following command:

```shell
npx hardhat run scripts/deploy.js --network <network-name>
```

## 🚀 Test

```shell
npx hardhat test
```

## 🔧 Usage

To interact with the PandoraNFT smart contract, you can use a variety of tools including Remix, Truffle, and Hardhat. To get started, simply connect to a local Ethereum network using Hardhat.

## ✅ Verified Smart Contract

Goerli:
```shell
https://goerli.etherscan.io/address/
```

## 👥 Contributing

We welcome contributions in the form of bug reports, feature requests, or pull requests. For more information, please see CONTRIBUTING.md.

## 🔓 License
[![MIT Licence](https://badges.frapsoft.com/os/mit/mit.svg?v=103)](https://opensource.org/licenses/mit-license.php)

This project is licensed under the MIT License - see the LICENSE file for details.