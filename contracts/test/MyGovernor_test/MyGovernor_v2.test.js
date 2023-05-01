// try creating a proposal to transfer ETH 
const { time, send } = require('@openzeppelin/test-helpers');
const { web3 } = require('@openzeppelin/test-helpers/src/setup');
const { assert } = require('chai');
const myGovernor = artifacts.require("MyGovernor");
const ERC20Token = artifacts.require("ERC20Token");
const Crowdsale = artifacts.require("Crowdsale");
const Timelock = artifacts.require("TimelockController");
contract("Setting MyGovernor to send ETH from timelock to account5", (accounts) => {
    let instance, erc, crowdsale, propose_res, timelock, govTimelock, bountyPropID, calldata;


    it("creating instance of MyGovernor,ERC20Token,CrowdSale,timelock contracts", async () => {
        instance = await myGovernor.deployed();
        erc = await ERC20Token.deployed()
        crowdsale = await Crowdsale.deployed();
        timelock = await Timelock.deployed();
        govTimelock = await instance.timelock()
        console.log("GOVERNOR Timelock", govTimelock)
        assert.equal(govTimelock, timelock.address, "Timelock Address does NOT matches ")
    })
    it("should transfer 50 tokens to crowdsale", async () => {
        let supply = await erc.totalSupply()
        let decimals = await erc.decimals()

        amount = 50
        newSupply = web3.utils.toWei(amount.toString(), 'ether')

        console.log("ToTal Token Suppli is ", newSupply, "old supply:", supply.toString());

        await erc.transfer(crowdsale.address, newSupply.toString());
        crowdsaleBal = await erc.balanceOf(crowdsale.address);
        account0Bal = await erc.balanceOf(accounts[0]);
        console.log("Balance for Crowdsale: ", crowdsaleBal.toString());
        console.log("Balance of Account0:", account0Bal.toString());

        await erc.transfer(timelock.address, "25");

    })

    it("Account 1,2,3,4 buy 1,2,3,4 tokens and delegates themselfs ", async () => {
        for (let i = 1; i < 5; i++) {
            await crowdsale.buyTokens(accounts[i], { from: accounts[i], value: web3.utils.toWei(`${i}`, 'ether') })
            await erc.delegate(accounts[i], { from: accounts[i] })
            const votes = await erc.getVotes(accounts[i])
            // console.log("Votes for account ", i, " = votes");
            console.log("Votes for account ", i, " is ", votes.toString(), " votes");
            // assert.equal(await erc.getVotes(accounts[i]),web3.utils.toWei(`${i}`, 'ether'),`Not all TokenHolders got delegated- issue:${i}`)
        }
    })
    //TODO: Change timelock proposer to Governor contract.
    it("should change the timelock proposer", async () => {

        proposerRole = await timelock.PROPOSER_ROLE();
        govPrevProp = await timelock.hasRole(proposerRole, instance.address);
        grantRole = await timelock.grantRole(proposerRole, instance.address);
        govNewProp = await timelock.hasRole(proposerRole, instance.address);
        console.log("Now does governor have proposal Role:", govNewProp);
        assert(govNewProp, true, "Govnor DOES NOT HAVE proposer role in Timelock")
    })
    //DONE: Send ETH collected to Timelock and check balance

    it("Should send 10 ETH to timelock Contract", async () => {
        // timelockAddr = await instance.timelock()
        // console.log("Timelock Address:", timelockAddr);
        transferFunds = await timelock.send(10, { from: accounts[0] });
        timelockBalance = await web3.eth.getBalance(timelock.address)
        console.log("Timelock ETH balance:", timelockBalance);

        assert.equal(timelockBalance, 10, "Balance not 10 ETH");

    })

    it("Should send 10 ETH to instance Contract", async () => {
        await web3.eth.sendTransaction({from:accounts[0],to:instance.address,value:1000000000000000000})
        await web3.eth.getBalance(instance.address, function(error, result) {
            console.log("instance.address balance", result.toString());
        });
    })
    it("Grant access to myGoverner to transfer ", async () => {
        // EXECUTOR_ROLE
        Executor = await timelock.EXECUTOR_ROLE();
        await timelock.grantRole(Executor, instance.address);
        console.log("ExecutorRole assigned", await timelock.hasRole(Executor, instance.address));
    })

    // Tokens transfer to account 5 proposals
    // TODO: change proposals to send ETH
    it("should create a proposal to fund 10 ETH to timelock contract", async () => {
        calldata=instance.contract.pay_transfer(accounts[9],10000000).encodeABI()
        // Number(web3.utils.toWei("5", 'ether'))
        bountyProposal = await instance.propose([instance.address], [0], [calldata], "Transfer funds", { from: accounts[2] });
        bountyPropID = (await bountyProposal.logs[0].args.proposalId).toString();
        console.log("Bounty Proposal ID:", bountyPropID)
        // dummy transaction
        await instance.propose([accounts[9]], [0], [calldata], "Gra ", { from: accounts[4] });
    })
    it("cast vote and check DEADLINE SNAPSHORT and Votes status", async () => {
        // Cast vote
        await instance.castVote(bountyPropID, 1, { from: accounts[1] });
        await instance.castVote(bountyPropID, 1, { from: accounts[2] });
        await instance.castVote(bountyPropID, 1, { from: accounts[3] });
        await instance.castVote(bountyPropID, 1, { from: accounts[4] });
    })

    it("Queue proposal and change time", async () => {
        descriptionHash = web3.utils.keccak256("Transfer funds");

        calldata=instance.contract.pay_transfer(accounts[9],10000000).encodeABI()
        // Queue
        bountyQueue = await instance.queue([instance.address], [0], [calldata], descriptionHash, { from: accounts[2] });
        bountyQueue = (await bountyProposal.logs[0].args.proposalId).toString();
        console.log("bounty Queue:", bountyQueue);
        // set time
        await time.increase(time.duration.seconds(10));
    })
    it("Execute proposal", async () => {
        descriptionHash = web3.utils.keccak256("Transfer funds");

        // calldata=instance.pay_transfer(accounts[9],10000000).encodeABI()
        calldata=instance.contract.pay_transfer(accounts[9],10000000).encodeABI()

        // Execution
        bountyExecute = await instance.execute([instance.address], [0], [calldata], descriptionHash, { from: accounts[2] });
        bountyExecuteID = (await bountyProposal.logs[0].args.proposalId).toString();
        console.log("Bounty Execute:", bountyExecuteID);

        await web3.eth.getBalance(timelock.address, function(error, result) {
            console.log("Bal of 5 after Execution", result.toString());
        });
        state = await instance.state(bountyPropID);
        console.log("state after execution", state.toString());

    })
})