require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
// module.exports = {
//   solidity: "0.8.17",
//   networks: {
//     hardhat: {
//       forking: {
//         url: "https://eth-mainnet.g.alchemy.com/v2/7x1Kt1kFNw6_BiGstLbaZCNCWrOlYsyO"
//       },
//       chainId: 1,
//     },
//   },
// };


//For Deploy on goerli network.
const ALCHEMY_API_KEY = "";
const GOERLI_PRIVATE_KEY = "";
module.exports = {
  solidity: "0.8.17",
  networks: {
    goerli: {
      url: `https://eth-goerli.g.alchemy.com/v2/${ALCHEMY_API_KEY}`,
      accounts: [GOERLI_PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: {
      goerli: "APCDGPYPNSB2BQ18Z9GUFPTCXAX654BJF1"
    }
  },
};