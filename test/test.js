//const { getNamedAccounts, deployments } = require("@nomiclabs/hardhat");
const { ethers } = require("ethers");
// const pandoraNFT = artifacts.require("pandoraNFT");

let contract, accounts, owner, user;

beforeEach(async () => {
  accounts = await ethers.getSigners();
  // accounts = await getNamedAccounts();
  owner = accounts.deployer;
  user = accounts[0].address;

//  contract = await pandoraNFT.deployments.get();
  // contract = await deployments.get(pandoraNFT);
});

describe("NFT Test", function(){
  async function runEveryTime(){
    console.log("Owner:",owner);
    console.log("User",user);
  }
  runEveryTime();
});
// describe("pandoraNFT", () => {
//   it("deploys and initializes successfully", async () => {
//     assert.ok(contract.address);
//   });

//   // it("calls the teamNFTMint method successfully", async () => {
//   //   // set teamMintActive flag to true
//   //   await contract.functions.setTeamMintActive(true);

//   //   console.log("Set TEAM MINT");
//   //   // add the user to the team whitelist
//   //   await contract.functions.addToTeamWhitelist(user, 10);
//   //   console.log(`Add address to teamWhitelist ${user}`);

//   //   // check the initial balance of the user
//   //   let balance = await contract.functions.balanceOf(user);
//   //   assert.equal(balance, 0);
//   //   console.log(`Balance ${balance}`);

//   //   // estimate gas for the call
//   //   let gas = await contract.functions.teamNFTMint(user, 1).estimateGas();

//   //   // sign the transaction
//   //   let signer = ethers.provider.getSigner(user);
//   //   let transaction = contract.functions.teamNFTMint(user, 1);
//   //   transaction.gasPrice = 20 * 10 ** 9;
//   //   transaction.gasLimit = gas;
//   //   let signedTransaction = await signer.sign(transaction);

//   //   // send the transaction
//   //   let receipt = await signedTransaction.send();
//   //   console.log(receipt);

//   //   // check the balance of the user
//   //   balance = await contract.functions.balanceOf(user);
//   //   assert.equal(balance, 1);
//   // });
// });
