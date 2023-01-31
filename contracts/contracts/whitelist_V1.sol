// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Context.sol";

contract AccessList is Context, Ownable {

    mapping(address => bool) public whitelist;
    mapping(address => bool) public blacklist;
    modifier checkWhiteList(){
        require(whitelist[_msgSender()], "NOT_IN_WHITELIST");
        _;
    }
    modifier checkBlackList(){
        require(!blacklist[_msgSender()], "IN_BLACKLIST");
        _;
    }
    /**
     * @notice Add to blacklist
     */
    function addToBlacklist(address[] calldata toAddAddresses) 
    external onlyOwner
    {
        for (uint i = 0; i < toAddAddresses.length; i++) {
            blacklist[toAddAddresses[i]] = true;
        }
    }

    /**
     * @notice Remove from blacklist
     */
    function removeFromBlacklist(address[] calldata toRemoveAddresses)
    external onlyOwner
    {
        for (uint i = 0; i < toRemoveAddresses.length; i++) {
            delete blacklist[toRemoveAddresses[i]];
        }
    }
    function addToWhitelist(address[] calldata toAddAddresses) 
    external onlyOwner
    {
        for (uint i = 0; i < toAddAddresses.length; i++) {
            whitelist[toAddAddresses[i]] = true;
        }
    }

    /**
     * @notice Remove from whitelist
     */
    function removeFromWhitelist(address[] calldata toRemoveAddresses)
    external onlyOwner
    {
        for (uint i = 0; i < toRemoveAddresses.length; i++) {
            delete whitelist[toRemoveAddresses[i]];
        }
    }

    /**
     * @notice Function with whitelist
     */
    // function whitelistFunc() view internal returns(bool)
    // {
    //     require(whitelist[msg.sender], "NOT_IN_WHITELIST");
    //     return true;
    // }
}