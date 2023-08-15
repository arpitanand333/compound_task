const { expect } = require("chai");
const hre = require("hardhat");
const { BigNumber } = require("ethers");

const abi = require("../artifacts/contracts/ERC20Contract.sol/ERC20Contract.json")

const sleep = ms => new Promise(res => setTimeout(res, ms));

describe("MyToken", () => {
  let USDC, usdcContract, cToken, MyToken, myToken, receiver
  before(async () => {
    [owner, receiver] = await hre.ethers.getSigners();
    console.log(owner.address, receiver.address);
    
    USDC = "0x07865c6E87B9F70255377e024ace6630C1Eaa37F";
    cToken = "0x73506770799Eb04befb5AaE4734e58C2C624F493";
  
    MyToken = await hre.ethers.getContractFactory("MyToken");
    myToken = await MyToken.deploy(cToken, USDC)
    await myToken.deployed()

    console.log("USDC address", USDC);
    console.log("cToken address", cToken);
    console.log("token address", await contractAddress.getAddress());

    usdcContract = await hre.ethers.getContractAt(abi.abi, USDC)
    console.log("usdcContract", await usdcContract);

    await usdcContract.approve(myToken.getAddress(), 100 * 10 ** 6)

    console.log(await usdcContract.allowance(owner.address, myToken.getAddress()));


  })


  it("Should mint NFT", async () => {
    // const tx = await myToken.safeMint(receiver.address);

    // console.log(tx);
  })



});
