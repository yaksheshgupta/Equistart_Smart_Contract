# CrowdSale docs

All the codes used were audited by openzepplin till solidity version - ^0.5.0 but dis continued after 0.6.0 update due to contract complexities.

[Official OpenZepplin docs](https://docs.openzeppelin.com/contracts/2.x/crowdsales)


### All the crowdsale used are-
1. AllowanceCrowdsale-
   1. AllowanceCrowdsale
   2. Crowdsale (Main File)
2. Caped and Timed CrowdSale
   1. TimedCrowdsale
   2. CappedCrowdsale
   3. Crowdsale (Main File)
3. Post Delevery and White listed CrowdSale (Important)
   1. RefundablePostDeliveryCrowdsale
   2. PostDeliveryCrowdsale
   3. FinalizableCrowdsale
   4. RefundableCrowdsale
   5. WhitelistCrowdsale
   6. TimedCrowdsale
   7. Crowdsale (Main File)


## Brief Discription of each contract used-
### 1. Crowdsale-
    They let you allocate tokens to network participants in various ways, mostly in exchange for Ether
### 2. TimedCrowdsale-
    Crowdsale accepting contributions only within a time frame.
    It allows owner to set a start and end time of the CrowdSale.
### 3. WhitelistCrowdsale-
    Crowdsale in which only whitelisted users can contribute.
    It gives owner the flexibity which provides user to select some wallets to participate in CrowdSale
### 4. FinalizableCrowdsale-
    Extension of TimedCrowdsale with a one-off finalization action, where one can do extra work after finishing.
### 5. PostDeliveryCrowdsale-
    Crowdsale that locks tokens from withdrawal until it ends.
    And when the CrowdSale is over the tokens are distributed to the investers.

### 6. RefundableCrowdsale-
    Extension of FinalizableCrowdsale contract that adds a funding goal, and the possibility of users getting a refund if goal is not met.
    ** Deprecated, use RefundablePostDeliveryCrowdsale instead. **

### 7.  RefundablePostDeliveryCrowdsale-
    Extension of RefundableCrowdsale contract that only delivers the tokens once the crowdsale has closed and the goal met, preventing refunds to be issued to token holders.


### 8. AllowanceCrowdsale-
    Use an AllowanceCrowdsale to send tokens from another wallet to the participants of the crowdsale. In order for this to work, the source wallet must give the crowdsale an allowance via the ERC20 approve method.



### 9. Minted Crowdsale- (This CrowdSale is not used)
    To use a MintedCrowdsale, your token must also be a ERC20Mintable token that the crowdsale has permission to mint from.


There is one more type of CrowdSale- "IncreasingPriceCrowdsale"
it is available on openzepplin github but is not audited hence, in openzepplin docs it is not present.

To Learn more on TestCases read [notes.txt](../notes.txt)
