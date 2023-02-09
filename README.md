# PandoraNFT

This repository contains the code for the PandoraNFT smart contract. The smart contract is a Non-Fungible Token (NFT) that is used to represent unique assets within the Pandora ecosystem. A smart contract for creating and managing NFTs on the Ethereum blockchain. 

## Table of Contents
- [PandoraNFT](#pandoranft)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Features](#features)
  - [Requirements](#requirements)
  - [Installation and Deployment](#installation-and-deployment)
  - [Install the Dependencies and Dotenv](#install-the-dependencies-and-dotenv)
  - [Create .env file](#create-env-file)
  - [Compiling the Smart Contracts](#compiling-the-smart-contracts)
  - [Deploying to a Network](#deploying-to-a-network)
  - [Test](#test)
  - [Usage](#usage)
  - [Verified Smart Contract](#verified-smart-contract)
    - [Goerli:](#goerli)
  - [License](#license)

## Introduction

PandoraNFT is an open-source, flexible and scalable smart contract for creating and managing NFTs on the Ethereum blockchain. It is designed to handle all the important aspects of NFTs including creation, transfer, and ownership, with easy to use functions.

## Features

- Create NFTs with unique identifiers
- Transfer NFTs to different Ethereum addresses
- Set different minting status for team, airdrop, whitelist and public
- Manage NFT ownership

## Requirements

- [Node.js](https://nodejs.org/en/)
- [NPM](https://www.npmjs.com/)
- [Hardhat](https://hardhat.org/)

## Installation and Deployment

1. Clone this repository
   
```shell
https://github.com/alex-necsoiu/pandora-nft
```

## Install the Dependencies and Dotenv

```shell
npm install
yarn install
```

## Create .env file

```shell
RPC_URL=""
PRIVATE_KEY=""
ETHERSCAN_API=""
```

## Compiling the Smart Contracts

```shell
npx hardhat clean
npx hardhat compile
```


## Deploying to a Network

```shell
npx hardhat run scripts/deploy.js --network <network-name>
```

## Test

```shell
npx hardhat test
```

## Usage

To interact with the PandoraNFT smart contract, you can use a variety of tools including Remix, Truffle, and Hardhat. To get started, simply connect to a local Ethereum network using Hardhat.

## Verified Smart Contract

### Goerli:
```shell
https://goerli.etherscan.io/address/
```
## License
This project is licensed under the MIT License - see the LICENSE file for details.