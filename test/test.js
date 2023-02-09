const { expect } = require("chai");
const { ethers, upgrades } = require("hardhat");

describe("PandoraNFT Unit Test:", function(){
  let pandoraNFT;
  let accounts;

  before(async function () {
    accounts = await ethers.getSigners();
    const pandoraNFTFactory = await ethers.getContractFactory("pandoraNFT");

    pandoraNFT = await upgrades.deployProxy(
      pandoraNFTFactory,
      [
        accounts[0].address, // Admin
        accounts[1].address, // Treasury
      ],
      {
        kind:"uups",
      } 
    );
    
    await pandoraNFT.deployed();

    console.log(`Contract deploy with address:${pandoraNFT.address}`);
  });

  it("Activate team minting status with wrong admin", async () => {
    await expect(
      pandoraNFT.connect(accounts[1]).setMintStatus(true,false,false,false)
    ).to.be.rejectedWith("Ownable: caller is not the owner");
  });

  it("Mint from team whitelist but minting not started", async () => {
    await expect(
      pandoraNFT.connect(accounts[10]).teamNFTMint(accounts[10].address, 1)
    ).to.be.revertedWith("Team Mint not started");
  });

  it("Mint from airdrop whitelist with wrong owner", async () => {
    await expect(
      pandoraNFT.connect(accounts[10]).airdropNFTMint(accounts[10].address, 1)
    ).to.be.revertedWith("Ownable: caller is not the owner");
  });

  it("Mint from airdrop whitelist but minting not started", async () => {
    await expect(
      pandoraNFT.connect(accounts[0]).airdropNFTMint(accounts[10].address, 1)
    ).to.be.revertedWith("Airdrop mint not started");
  });

  it("Mint from whitelist but minting not started", async () => {
    await expect(
      pandoraNFT.connect(accounts[10]).whitelistNFTMint(accounts[10].address, 1)
    ).to.be.revertedWith("Whitelist mint not started");
  });

  it("Public mint but minting not started", async () => {
    await expect(
      pandoraNFT.connect(accounts[10]).publicNFTMint(accounts[10].address, 1)
    ).to.be.revertedWith("Public mint not started");
  });

  it("Should activate minting for the team whitelist", async () => {
    await pandoraNFT.connect(accounts[0]).setMintStatus(true,false,false,false);
  });



  it("Should allow team whitelist to mint NFTs", async () => {
    teamWhiteListedAddresses = [
      accounts[10].address,
      accounts[11].address,
    ];
    await pandoraNFT.connect(accounts[0]).setWhitelist(
      teamWhiteListedAddresses,
      [1, 1],
      2
    );
    const originalSupply = await pandoraNFT.totalSupply();
    await pandoraNFT.connect(accounts[10]).teamNFTMint(accounts[10].address, 1,{value: ethers.utils.parseEther("0.001").toString()}
    );
    const newSupply = await pandoraNFT.totalSupply();
    expect(newSupply.sub(originalSupply)).to.equal(1);
    });
    
    it("Should allow airdrop whitelist to mint NFTs with the right owner", async () => {
    const originalSupply = await pandoraNFT.totalSupply();
    await pandoraNFT.connect(accounts[0]).setMintStatus(false,true,false,false);
    await pandoraNFT.connect(accounts[0]).airdropNFTMint(accounts[10].address, 1);
    const newSupply = await pandoraNFT.totalSupply();
    expect(newSupply.sub(originalSupply)).to.equal(1);
    });
    
    it("Should allow whitelist to mint NFTs", async () => {
    whitelisAddress = [
      accounts[10].address,
      accounts[11].address,
    ];
    await pandoraNFT.connect(accounts[0]).setWhitelist(
      whitelisAddress,
      [1, 1],
      1
    );
    const originalSupply = await pandoraNFT.totalSupply();
    await pandoraNFT.connect(accounts[0]).setMintStatus(false,false,true,false);
    await pandoraNFT.connect(accounts[10]).whitelistNFTMint(accounts[10].address, 1, {value: ethers.utils.parseEther("0.003").toString()});
    const newSupply = await pandoraNFT.totalSupply();
    expect(newSupply.sub(originalSupply)).to.equal(1);
    });
    
    it("Should allow public to mint NFTs", async () => {
    const originalSupply = await pandoraNFT.totalSupply();
    await pandoraNFT.connect(accounts[0]).setMintStatus(false,false,false,true);
    await pandoraNFT.connect(accounts[10]).publicNFTMint(accounts[10].address, 1,{value: ethers.utils.parseEther("0.005").toString()});
    const newSupply = await pandoraNFT.totalSupply();
    expect(newSupply.sub(originalSupply)).to.equal(1);
    });
    
    it("Should get the correct owner of an NFT", async () => {
    const owner = await pandoraNFT.ownerOf(1);
    expect(owner).to.equal(accounts[10].address);
    });

    
    // it("Should transfer an NFT to a new owner", async () => {
    // const originalOwner = await pandoraNFT.ownerOf(1);
    // await pandoraNFT.connect(originalOwner).transfer(accounts[11].address, 1);
    // const newOwner = await pandoraNFT.ownerOf(1);
    // expect(newOwner).to.equal(accounts[11].address);
    // });    
});