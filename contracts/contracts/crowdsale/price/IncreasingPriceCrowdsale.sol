// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../validation/TimedCrowdsale.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/**
 * @title IncreasingPriceCrowdsale
 * @dev Extension of Crowdsale contract that increases the price of tokens linearly in time.
 * Note that what should be provided to the constructor is the initial and final _rates_, that is,
 * the amount of tokens per wei contributed. Thus, the initial rate must be greater than the final rate.
 */
abstract contract IncreasingPriceCrowdsale is TimedCrowdsale {
    using SafeMath for uint256;

    uint256 private _initialRate;
    uint256 private _finalRate;

    constructor(uint256 initialRate_, uint256 finalRate_) {
        require(finalRate_ > 0, "IncreasingPriceCrowdsale: final rate is 0");
        // solhint-disable-next-line max-line-length
        require(
            initialRate_ > finalRate_,
            "IncreasingPriceCrowdsale: initial rate is not greater than final rate"
        );
        _initialRate = initialRate_;
        _finalRate = finalRate_;
    }

    /**
     * The base rate function is overridden to revert, since this crowdsale doesn't use it, and
     * all calls to it are a mistake.
     */
    function rate_() public pure returns (uint256) {
        // Name changes to rate_ from rate due to name conflicts from main CS file
        revert("IncreasingPriceCrowdsale: rate() called");
    }

    /**
     * @return the initial rate of the crowdsale.
     */
    function initialRate() public view returns (uint256) {
        return _initialRate;
    }

    /**
     * @return the final rate of the crowdsale.
     */
    function finalRate() public view returns (uint256) {
        return _finalRate;
    }

    /**
     * @dev Returns the rate of tokens per wei at the present time.
     * Note that, as price _increases_ with time, the rate _decreases_.
     * @return The number of tokens a buyer gets per wei at a given time
     */
    function getCurrentRate() public view returns (uint256) {
        if (!isOpen()) {
            return 0;
        }

        // solhint-disable-next-line not-rely-on-time
        uint256 elapsedTime = block.timestamp.sub(openingTime());
        uint256 timeRange = closingTime().sub(openingTime());
        uint256 rateRange = _initialRate.sub(_finalRate);
        return _initialRate.sub(elapsedTime.mul(rateRange).div(timeRange));
    }

    /**
     * @dev Overrides parent method taking into account variable rate.
     * @param weiAmount The value in wei to be converted into tokens
     * @return The number of tokens _weiAmount wei will buy at present time
     */
    function _getTokenAmount(uint256 weiAmount)
        internal
        view
        virtual
        override
        returns (uint256)
    {
        uint256 currentRate = getCurrentRate();
        return currentRate.mul(weiAmount);
    }
}
