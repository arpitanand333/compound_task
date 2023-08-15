# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node --fork https://eth-mainnet.g.alchemy.com/v2/{"Please enter your API key"}
npx hardhat run scripts/deploy.js
npx hardhat run scripts/deploy.js --network goerli w
npx hardhat verify --network goerli contractAddr constructorArgument.