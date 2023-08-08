// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../emission/AllowanceCrowdSale.sol";
import "../Crowdsale.sol";

contract MYCS_ALLOWANCE is Crowdsale, AllowanceCrowdsale {
    constructor(
        address holder,
        uint256 _Rate,
        address payable _wallet,
        ERC20 _token
    ) Crowdsale(_Rate, _wallet, _token) AllowanceCrowdsale(holder){}

    function _deliverTokens(
        address beneficiary,
        uint256 tokenAmount
    ) internal override(AllowanceCrowdsale, Crowdsale) {
        super._deliverTokens(beneficiary, tokenAmount);
    }
}
