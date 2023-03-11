const { time, expectRevert } = require('@openzeppelin/test-helpers');
const { assert } = require('chai');
const crowdsale = artifacts.require("MYCS_POSTDEV_WHITE");
const ERC20Token = artifacts.require("ERC20Token");
contract("Crowdsale Test file", (accounts) => {
    let Crowdsale;
    let token;
    it("transfer token to crowdsale contract", async () => {
        return ERC20Token.deployed().then(ins => {
            token = ins;
            return crowdsale.deployed()
        }).then(async (res) => {
            Crowdsale = res;
            const totalSupply = await token.totalSupply();
            // console.log(totalSupply.toString());
            await token.transfer(res.address, totalSupply.toString());
            assert.equal(await token.balanceOf(accounts[0]), 0, "token not transafered");
        })
    })
    it("Send transction without alloting accounts[1] as whitelisted",async()=>{
        expectRevert(Crowdsale.sendTransaction({from:accounts[1],value:"10"}),"TimedCrowdsale: not open -- Reason given: TimedCrowdsale: not open.")
    })
    it("whitelist account[1]",async()=>{
        await Crowdsale.addWhitelisted(accounts[1],{from:accounts[0]});
    })
    it("Checking finalize and goal reached rewards",async()=>{
        await time.increase(time.duration.seconds(10));
        await Crowdsale.sendTransaction({from:accounts[1],value:"1000000000000000001"});        await time.increase(time.duration.seconds(100));
        goalReached=await Crowdsale.goalReached()  
        assert.equal(goalReached,true,"Goal not reached")
        await Crowdsale.finalize();
        // Crowdsale finished
    })
    it("Withdraw token after Crowdsale is finished",async()=>{
        await Crowdsale.withdrawTokens(accounts[1])
        console.log("Token balance accounts[1]--",(await token.balanceOf(accounts[1])).toString());
        assert.equal((await token.balanceOf(accounts[1])).toString(),"1000000000000000001","Not 1^18 token transfer")
    })
    it("try to claimRefund after the success of CS",async()=>{
        expectRevert(Crowdsale.claimRefund(accounts[1]),"Issue in Crowdsale");
    })

})
// await time.increase(time.duration.seconds(10)); 
