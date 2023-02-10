// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../validation/TimedCrowdsale.sol";
import "../validation/CappedCrowdsale.sol";
import "../Crowdsale.sol";

contract MYCS_Capped_Timed is Crowdsale, CappedCrowdsale, TimedCrowdsale {
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

    // LOWER FUNCTION JUST FOR CHECKING ---- NO IMPACT ON MAIN CODE
    function timeStamp() public view returns (uint256) {
        return block.timestamp;
    }

    function timeDiffrenceToOpen() public view returns (uint256) {
        return block.timestamp - openingTime();
    }

    function timeDiffrenceToClose() public view returns (uint256) {
        return closingTime() - block.timestamp;
    }

    function _preValidatePurchase(address beneficiary, uint256 weiAmount)
        internal
        view
        override(CappedCrowdsale, Crowdsale, TimedCrowdsale)
        onlyWhileOpen
    {
        super._preValidatePurchase(beneficiary, weiAmount);
    }
}
