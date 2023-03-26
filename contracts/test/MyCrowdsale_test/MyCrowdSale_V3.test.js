const { time, expectRevert } = require('@openzeppelin/test-helpers');
const { assert } = require('chai');
const crowdsale = artifacts.require("MYCS_ALLOWANCE");
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
        })
    })
    it("Allowing CrowdSale to sale ERC20", async () => {
        const totalSupply = await token.totalSupply();
        await token.approve(crowdsale.address, totalSupply);
    })
    it("buying tokens from account5 using allowance", async () => {
        await Crowdsale.sendTransaction({ from: accounts[2], value: "10000" });
        console.log((await token.balanceOf(accounts[2])).toString());
        assert((await token.balanceOf(accounts[2])).toString(),10000,"Token not transfered")
    })

})
// await time.increase(time.duration.seconds(10));

// const totalSupply = await token.totalSupply();
// // console.log(totalSupply.toString());
// await token.transfer(res.address, totalSupply.toString());
// assert.equal(await token.balanceOf(accounts[0]), 0, "token not transafered");