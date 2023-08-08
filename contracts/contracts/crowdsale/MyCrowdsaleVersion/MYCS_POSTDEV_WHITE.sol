// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../distribution/RefundablePostDeliveryCrowdsale.sol";
import "../distribution/PostDeliveryCrowdsale.sol";
import "../distribution/FinalizableCrowdsale.sol";
import "../distribution/RefundableCrowdsale.sol";
import "../validation/WhitelistCrowdsale.sol";
import "../validation/TimedCrowdsale.sol";
import "../Crowdsale.sol";

contract MYCS_POSTDEV_WHITE is
    Crowdsale,
    WhitelistCrowdsale,
    TimedCrowdsale,
    PostDeliveryCrowdsale,
    FinalizableCrowdsale,
    RefundableCrowdsale,
    RefundablePostDeliveryCrowdsale
{
    constructor(
        uint256 goal,
        uint256 openingTime_,
        uint256 closingTime_,
        uint256 _Rate,
        address payable _wallet,
        ERC20 _token
    )
        PostDeliveryCrowdsale()
        FinalizableCrowdsale()
        Crowdsale(_Rate, _wallet, _token)
        RefundableCrowdsale(goal)
        TimedCrowdsale(openingTime_, closingTime_)
    {}

    function _forwardFunds()
        internal
        override(
            Crowdsale,
            RefundablePostDeliveryCrowdsale,
            RefundableCrowdsale
        )
    {
        super._forwardFunds();
    }

    function _preValidatePurchase(address beneficiary, uint256 weiAmount)
        internal
        view
        override(TimedCrowdsale, WhitelistCrowdsale, Crowdsale)
    {
        super._preValidatePurchase(beneficiary, weiAmount);
    }

    function _processPurchase(address beneficiary, uint256 tokenAmount)
        internal
        override(
            Crowdsale,
            RefundablePostDeliveryCrowdsale,
            PostDeliveryCrowdsale
        )
    {
        super._processPurchase(beneficiary, tokenAmount);
    }

    function _finalization()
        internal
        override(FinalizableCrowdsale, RefundableCrowdsale)
    {
        super._finalization();
    }

    function withdrawTokens(address beneficiary)
        public
        override(PostDeliveryCrowdsale, RefundablePostDeliveryCrowdsale)
    {
        super.withdrawTokens(beneficiary);
    }
}
