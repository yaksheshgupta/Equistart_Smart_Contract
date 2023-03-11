// const MYCROWDSALE = artifacts.require("MYCS_Capped_Timed");
const MYCROWDSALE = artifacts.require("MYCS_POSTDEV_WHITE");
const ERC20Token = artifacts.require("ERC20Token");
const CAP_SIZE = 10;
const GOAL=100;
const TOKEN_NAME = "Equistart";
const TOKEN_SYMBOL = "EQST";
const TOKEN_SUPPLY=1000;
const WALLET = "0xf5cC334A7FC8Ece6fe31C686A362db544cf38D2B";

// 5mins=300 sec
// 1mins=60 sec
const OPENING_TIME_ADD = 10;
const CLOSING_TIME_ADD = 600;
const RATE = 1;
module.exports = (deployer) => {
  deployer.deploy(ERC20Token, TOKEN_NAME,TOKEN_SYMBOL, TOKEN_SUPPLY, WALLET).then(() => {
    console.log("ERC 20 Token Contract address:", ERC20Token.address);
    // return deployer.deploy(MYCROWDSALE, CAP_SIZE, Math.floor(Date.now() / 1000) + OPENING_TIME_ADD, Math.floor(Date.now() / 1000) + CLOSING_TIME_ADD, RATE, WALLET, ERC20Token.address)
    // 👆 MYCS_Capped_Timed
    // return deployer.deploy(MYCROWDSALE, GOAL, Math.floor(Date.now() / 1000) + OPENING_TIME_ADD, Math.floor(Date.now() / 1000) + CLOSING_TIME_ADD, RATE, WALLET, ERC20Token.address)
    // 👆 MYCS_POSTDEV_WHITE
  }).then(()=>{
    console.log("MyCrowdSale Contract address:", MYCROWDSALE.address);
  })
};
// Not implementing MYCS_MINTABLE caz it requires a MintableERC contract. 