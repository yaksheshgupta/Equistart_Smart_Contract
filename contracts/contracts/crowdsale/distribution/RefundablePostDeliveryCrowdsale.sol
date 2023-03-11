// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./RefundableCrowdsale.sol";
import "./PostDeliveryCrowdsale.sol";

/**
 * @title RefundablePostDeliveryCrowdsale
 * @dev Extension of RefundableCrowdsale contract that only delivers the tokens
 * once the crowdsale has closed and the goal met, preventing refunds to be issued
 * to token holders.
 */

abstract contract RefundablePostDeliveryCrowdsale is
    PostDeliveryCrowdsale,
    RefundableCrowdsale
{
    function _forwardFunds()
        internal
        virtual
        override(Crowdsale, RefundableCrowdsale)
    {
        super._forwardFunds();
    }

    function _processPurchase(address beneficiary, uint256 tokenAmount)
        internal
        virtual
        override(Crowdsale, PostDeliveryCrowdsale)
    {
        super._processPurchase(beneficiary, tokenAmount);
    }

    function withdrawTokens(address beneficiary) public virtual override {
        require(finalized(), "RefundablePostDeliveryCrowdsale: not finalized");
        require(
            goalReached(),
            "RefundablePostDeliveryCrowdsale: goal not reached"
        );

        super.withdrawTokens(beneficiary);
    }
}

// RefundableCrowdsale(goal_,openingTime_, closingTime_, tkn, rate_, owner)
