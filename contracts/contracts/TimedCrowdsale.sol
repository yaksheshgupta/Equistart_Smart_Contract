// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";

contract TimedCrowdsale is Ownable{
    // Opening time of the crowdsale
    uint256 private openingtime;
    // Closing time of the crowdsale
    uint256 private closingtime;

    event TimedCrowdsaleExtended(
        string typechanged,
        uint256 prevClosingTime,
        uint256 newClosingTime
    );

    constructor(uint256 _openingtime, uint256 _closingtime) {
        require(_openingtime >= block.timestamp, "opening time wrong"); // turant ya baad me open kr do
        require(_openingtime<_closingtime,"opening time > closing time"); // open pehle close baad me

        openingtime = _openingtime;
        closingtime = _closingtime;
    }

    // modifier to check if time permits
    modifier onlyWhileOpen() {
        require(openingtime <= block.timestamp, "Crowdsale is not started"); //CHECK
        require(closingtime >= block.timestamp, "Crowdsale finished");
        _;
    }

    function Openingtime() public view returns (uint256) {
        return openingtime;
    }

    function Closingtime() public view returns (uint256) {
        return closingtime;
    }

    function isOpen() public view returns (bool) {
        return (openingtime <= block.timestamp && block.timestamp<closingtime) ? true : false;
    }

    function isClose() public view returns (bool) {
        return (openingtime > block.timestamp || block.timestamp>closingtime) ? true : false;
    }


    function _extendTime(uint256 _newclosingtime) internal onlyOwner virtual returns (bool) {
        require(openingtime < _newclosingtime);
        uint256 prevTime = closingtime;
        closingtime = _newclosingtime;
        emit TimedCrowdsaleExtended(
            "Closing time edited",
            prevTime,
            _newclosingtime
        );
        return true;
    }
}
