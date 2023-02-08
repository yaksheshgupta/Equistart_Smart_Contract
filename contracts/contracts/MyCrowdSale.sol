// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./crowdsale/validation/TimedCrowdsale.sol";
import "./crowdsale/validation/CappedCrowdsale.sol";
import "./crowdsale/Crowdsale.sol";

contract MyCrowdSale is Crowdsale, CappedCrowdsale, TimedCrowdsale {
    constructor(
        uint256 cap,
        uint256 _openingTime,
        uint256 _closingTime,
        uint256 _Rate,
        address payable _wallet,
        IERC20 _token
    )
        CappedCrowdsale(cap)
        TimedCrowdsale(_openingTime, _closingTime)
        Crowdsale(_Rate, _wallet, _token)
    {}

    function _preValidatePurchase(address beneficiary, uint256 weiAmount)
        internal
        view
        override(CappedCrowdsale, Crowdsale, TimedCrowdsale)
        onlyWhileOpen
    {
        super._preValidatePurchase(beneficiary, weiAmount);
    }

    // LOWER FUNCTION JUST FOR CHECKING ---- NO IMPACT ON MAIN CODE
    function timeStamp()public view returns (uint) {
        return block.timestamp;
    }
    function timeDiffrenceToOpen()public view returns (uint) {
        return block.timestamp-openingTime();
    }
    function timeDiffrenceToClose()public view returns (uint) {
        return closingTime()-block.timestamp;
    }
}
