// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ERC1155_Equistart_V1 is ERC1155, Ownable {
    // uint public constant JBonus=0;//20
    // uint public constant Winner=1;//721
    //🚨 VUL- Check if token id can be changed?
    //🚨 VUL- How to check if the token transfered to timelock is fungeble or non.
    uint[] public tokenIds;
    mapping(string => uint) public name_tokenids;
    // or ID=>string
// ----------- ANOTHER APPROACH
    struct token_home{
        uint id;
        string typof;
        string name;
        uint amount;
    }
    mapping (uint=>token_home) public map_TH;
    // ------
    constructor(
        uint256[] memory _id,
        string[] memory _name,
        uint256[] memory _amount,
        bytes[] memory _data
    ) ERC1155("https://ipfs.io/ipfs/HASH/{id}.json") {
        // _mint(msg.sender,JBonus,1000,"");
        // _mint(msg.sender,Winner,10,"");
        require(
            _id.length == _name.length &&
                _id.length == _amount.length &&
                _amount.length == _data.length,
            "ERROR: Invalid length parameters"
        );
        for (uint i = 0; i < _id.length; ++i) {
            require(name_tokenids[_name[i]] != 0,"Repeated tokens");
            // same id Issue
            tokenIds.push(_id[i]);
            name_tokenids[_name[i]] = _id[i];
            _mint(msg.sender, _id[i], _amount[i], _data[i]);
        }
    }

    function addTokenIds_mint(
        uint _id,
        string memory _name,
        uint _amount,
        bytes memory _data
    ) public onlyOwner returns (bool) {
        require(name_tokenids[_name] == 0);
        _mint(owner(), _id, _amount, _data);
        tokenIds.push(_id);
        name_tokenids[_name] = _id;
        return true;
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function uri(uint256 _tokenid) public pure override returns(string memory){
        return string(abi.encodePacked("https://ipfs.io/ipfs/HASH/", Strings.toString(_tokenid),".json"));
    }
}
