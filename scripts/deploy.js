const pandoraNFT= require("hardhat");
async function main() {
  const pandoraNFTFactory = await pandoraNFT.ethers.getContractFactory("pandoraNFT");
  const contract = await pandoraNFTFactory.deploy();

  await contract.deployed();

  console.log(`Contract deploy with address:${contract.address}`);
}

main()
.then(() => process.exit(0))
.catch((error) => {
  console.error(error);
  process.exit(1);
});
