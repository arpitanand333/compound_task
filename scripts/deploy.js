const hre = require("hardhat");

async function main() {
  

  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const USDC = "0x07865c6E87B9F70255377e024ace6630C1Eaa37F";
  const cToken = "0x73506770799Eb04befb5AaE4734e58C2C624F493";

  const myContract = await hre.ethers.deployContract("MyToken", [cToken, USDC]);

  let contractAddress = await myContract.waitForDeployment();
  console.log("Deployed contact address is: ",await contractAddress.getAddress());
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
