const { time } = require('@openzeppelin/test-helpers');
const { assert } = require('chai');
const crowdsale = artifacts.require("MyCrowdSale");
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
            await token.transfer(res.address, totalSupply.toString());
            assert.equal(await token.balanceOf(accounts[0]), 0, "token not transafered");
        })
    })
    it("Try buying tokens from crowdsale after opeingTime with cap-10", async () => {
        await time.increase(time.duration.seconds(10));
        // It  increases the time in ganache but do not reset it to not default 
        // creates problem to run tests multiple time 
        const openingTime = await Crowdsale.openingTime();
        console.log(openingTime.toString());
        console.log((await Crowdsale.timeStamp()).toString());
        await Crowdsale.sendTransaction({ from: accounts[1], value: "10" })
        console.log((await token.balanceOf(accounts[1])).toString());
    })
    it("Try buying tokens from crowdsale under CAP_size", async () => {

    })
})
// await time.increase(time.duration.seconds(10)); 
