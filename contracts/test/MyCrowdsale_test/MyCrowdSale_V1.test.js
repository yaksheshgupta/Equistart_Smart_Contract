const { time, expectRevert } = require('@openzeppelin/test-helpers');
const { assert } = require('chai');
const crowdsale = artifacts.require("MYCS_Capped_Timed");
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
            console.log(totalSupply.toString());
            await token.transfer(res.address, totalSupply.toString());
            assert.equal(await token.balanceOf(accounts[0]), 0, "token not transafered");
        })
    })
    it("Try buying tokens from crowdsale before opening time", async () => {
        // await Crowdsale.sendTransaction({ from: accounts[1], value: "10" }).catch((err)=>{
        //     console.log("reverting on before given time ");
        // })
        // expectRevert(Crowdsale.sendTransaction({ from: accounts[1], value: "10" }), "revert")
        expectRevert(Crowdsale.sendTransaction({ from: accounts[1], value: "10" }), "out of gas") // CHECK
    })
    it("Try buying tokens from crowdsale over CAP_size i.e 10", async () => {
        await time.increase(time.duration.seconds(10));
        // await Crowdsale.sendTransaction({ from: accounts[1], value: "11" }).catch((err)=>{
        //     console.log("reverting on <10");
        // })
        expectRevert(Crowdsale.sendTransaction({ from: accounts[1], value: "11" }), "CappedCrowdsale: cap exceeded -- Reason given: CappedCrowdsale: cap exceeded.")

    })
    it("Try buying tokens from crowdsale after opeingTime with cap-10", async () => {
        // It  increases the time in ganache but do not reset it to not default 
        // creates problem to run tests multiple time 
        const openingTime = await Crowdsale.openingTime();
        console.log(openingTime.toString());
        console.log((await Crowdsale.timeStamp()).toString());
        await Crowdsale.sendTransaction({ from: accounts[1], value: "10" })
        assert.equal(await token.balanceOf(accounts[1]), 10, "token not transafered");
    })
    it("Try buying tokens from crowdsale after closing time", async () => {
        await time.increase(time.duration.seconds(610));
        // await Crowdsale.sendTransaction({ from: accounts[1], value: "10" }).catch((err)=>{
        //     console.log("reverting as crowdsale is closed----",err);
        // })
        expectRevert(Crowdsale.sendTransaction({ from: accounts[1], value: "10" }), "reverting as crowdsale is closed")
    })
})
// await time.increase(time.duration.seconds(10)); 
