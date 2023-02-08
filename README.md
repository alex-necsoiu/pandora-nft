# pandora-nft
Pandora Labs NFT's with whitelist and airdrop presale

# Create Pandora NFT Collection

NOTE: smart contract will be verified on etherscan when you run deploy script

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
npx hardhat compile
```

## Deploy Smart Contracts on Goerli Network

```shell
npx hardhat run --network goerli scripts/deploy.js
```

## Verified Smart Contract

### Goerli:
```shell
https://goerli.etherscan.io/address/
```
### Rinkeby:
```shell
https://rinkeby.etherscan.io/address/
```