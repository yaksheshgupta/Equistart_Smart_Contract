// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../price/IncreasingPriceCrowdsale.sol";
import "../validation/IndividuallyCappedCrowdsale.sol";
import "../validation/TimedCrowdsale.sol";
import "../Crowdsale.sol";

contract MYCS_INCPRICE_INDICAP is
    Crowdsale,
    TimedCrowdsale,
    IncreasingPriceCrowdsale,
    IndividuallyCappedCrowdsale
{
    constructor(
        uint256 _openingTime,
        uint256 _closingTime,
        uint256 _initialRate,
        uint256 _finalRate,
        uint256 _Rate,
        address payable _wallet,
        IERC20 _token
    )
        Crowdsale(_Rate, _wallet, _token)
        TimedCrowdsale(_openingTime, _closingTime)
        IncreasingPriceCrowdsale(_initialRate, _finalRate)
    {}

    function _updatePurchasingState(address beneficiary, uint256 weiAmount)
        internal
        override(Crowdsale, IndividuallyCappedCrowdsale)
    {
        super._updatePurchasingState(beneficiary, weiAmount);
    }

    function _preValidatePurchase(address beneficiary, uint256 weiAmount)
        internal
        view
        override(Crowdsale, TimedCrowdsale, IndividuallyCappedCrowdsale)
    {
        super._preValidatePurchase(beneficiary, weiAmount);
    }

    function _getTokenAmount(uint256 weiAmount)
        internal
        view
        override(Crowdsale, IncreasingPriceCrowdsale)
        returns (uint256)
    {
        return super._getTokenAmount(weiAmount);
    }
}
