// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Hello_Collection is ERC1155, Ownable {

    uint public constant JBonus=0;
    uint public constant Winner=1;

    constructor() ERC1155("https://ipfs.io/ipfs/QmeXGt2J1ahhJ9xqyt6ort5MSPVuqMDNpwaoDCfSkVo6rn/{id}.json") {
        _mint(msg.sender,JBonus,1000,"");
        _mint(msg.sender,Winner,10,"");
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }
    function getURI() public pure returns(string memory){
        return("https://ipfs.io/ipfs/QmTzBd4VHRTLpXY11Hj9q16NMc4zGKWGe15ui65tm4cpgg/");
    }
}