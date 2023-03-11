const tokenFactory = artifacts.require("TokenFactory");
const ERC20Token = artifacts.require("ERC20Token");
const crowdsale = artifacts.require("Crowdsale");
const crowdsaleFactory = artifacts.require("CrowdsaleFactory");
const timelockController=artifacts.require("TimelockController");
const mygo=artifacts.require("MyGovernor");
const proposers= ["0xf5cC334A7FC8Ece6fe31C686A362db544cf38D2B"];
const executors= ["0xf5cC334A7FC8Ece6fe31C686A362db544cf38D2B"];
const owner="0xf5cC334A7FC8Ece6fe31C686A362db544cf38D2B"


module.exports =  (deployer)=> {
  deployer.deploy(tokenFactory);
  deployer.deploy(ERC20Token,"Yakshesh","YAKSH",100,owner).then(()=>{
    console.log("ERC 20 TOken Contract address:", ERC20Token.address);
    return deployer.deploy(crowdsale,1,owner,ERC20Token.address)
  })
  deployer.deploy(crowdsaleFactory);
  deployer.deploy(timelockController,5,proposers,executors).then(()=>{
     return deployer.deploy(mygo,ERC20Token.address,timelockController.address);
   })
};

// NO NEED FOR THIS AS DEVELOPING CROWDSALE
