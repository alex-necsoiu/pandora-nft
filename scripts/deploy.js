const { ethers, upgrades } = require("hardhat");
const { keccak256 } = ethers.utils;

// const padBuffer = (addr) => {
//   return Buffer.from(addr.substr(2).padStart(32 * 2, 0), "hex");
// };
const ENVIRONMENT = process.env.ENVIRONMENT;
// const admin = "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266";
// const treasury = "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266";
const admin = "0xa2f4F4e465AAE91241D61E3518c9f2e7cb74c014";
const treasury = "0xa2f4F4e465AAE91241D61E3518c9f2e7cb74c014";
// if (ENVIRONMENT == 'testnet') {
//   const admin = "0xa2f4F4e465AAE91241D61E3518c9f2e7cb74c014";
//   const treasury = "0xa2f4F4e465AAE91241D61E3518c9f2e7cb74c014";
// }else if (ENVIRONMENT == 'mainnet') {
//   const admin = "0xa2f4F4e465AAE91241D61E3518c9f2e7cb74c014";
//   const treasury = "0xa2f4F4e465AAE91241D61E3518c9f2e7cb74c014";
// }

const teamWhitelist = [
  "0xa2f4F4e465AAE91241D61E3518c9f2e7cb74c014",
  "0x225EBB792a900B29918feF50389d4AD2CD49321D",
  "0x65d68d5A1eC6Ef3c454BBA4Af0DdF08C0Ba5F10e",
  "0x62a6381Aaa2429dd389B7e481161fb8E2c0631D6",
  "0xe6863185F85f51a9e7F6838a816B1E105c6C0Eea"
];

const whitelist = [
  "0xa2f4F4e465AAE91241D61E3518c9f2e7cb74c014",
  "0x225EBB792a900B29918feF50389d4AD2CD49321D",
  "0x65d68d5A1eC6Ef3c454BBA4Af0DdF08C0Ba5F10e",
  "0x62a6381Aaa2429dd389B7e481161fb8E2c0631D6",
  "0xe6863185F85f51a9e7F6838a816B1E105c6C0Eea"
];
async function main() {

    const pandoraNFTFactory = await ethers.getContractFactory("pandoraNFT");
    console.log("ADMIN:",admin);
    console.log("Treasury",treasury);

    contract = await upgrades.deployProxy(
      pandoraNFTFactory,
      [
        admin, // Admin
        treasury, // Treasury
      ],
      {
        kind:"uups",
      } 
    );
    
  await contract.deployed();
  console.log(`Contract deploy with address:${contract.address}`);
  console.log(`Contract signer address:${contract.signer.address}`);

  // Activate team minting status
  await contract.setMintStatus(true,false,false,false);

  // Add accounts to whitelist
  await contract.setWhitelist(
    whitelist,
    [1, 1,1,1, 1],
    1
  );
  console.log("Set whitelist!");

  // Add accounts to team whitelist
  await contract.setWhitelist(
    teamWhitelist,
    [1, 1,1,1, 1],
    2
  );
  console.log("Set team whitelist!");

  await contract.setBaseURI(
    "https://ipfs.io/ipfs/bafybeibu7rgw7zsutgptaxorty7rfheeelawc7qpywjiw4basm7b377llq/"
  );

  const implAddress = await upgrades.erc1967.getImplementationAddress(
    contract.address
  );

  await hre.run("verify:verify", {
    address: implAddress,
    constructorArguments: [],
  });

}

main()
.then(() => process.exit(0))
.catch((error) => {
  console.error(error);
  process.exit(1);
});
