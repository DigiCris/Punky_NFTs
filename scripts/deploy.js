const hre = require("hardhat");
const { expect } = require("chai");
const { ethers } = require("hardhat");

const maxSupply = 10000;

async function main() {
  const [deployer] = await ethers.getSigners();
  const Nft = await ethers.getContractFactory("PlatziPunks");
  const nft = await Nft.deploy(maxSupply);

  await nft.deployed();

  console.log("Address de la Wallet:", deployer.address);
  console.log("deployado:", nft.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
