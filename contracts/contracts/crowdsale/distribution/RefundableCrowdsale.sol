// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./FinalizableCrowdsale.sol";
import "../utils/escrow/RefundEscrow.sol";

/**
 * @title RefundableCrowdsale
 * @dev Extension of `FinalizableCrowdsale` contract that adds a funding goal, and the possibility of users
 * getting a refund if goal is not met.
 *
 * Deprecated, use `RefundablePostDeliveryCrowdsale` instead. Note that if you allow tokens to be traded before the goal
 * is met, then an attack is possible in which the attacker purchases tokens from the crowdsale and when they sees that
 * the goal is unlikely to be met, they sell their tokens (possibly at a discount). The attacker will be refunded when
 * the crowdsale is finalized, and the users that purchased from them will be left with worthless tokens.
 */
abstract contract RefundableCrowdsale is Context, FinalizableCrowdsale {
    using SafeMath for uint256;

    // minimum amount of funds to be raised in weis
    uint256 private _goal;

    // refund escrow used to hold funds while crowdsale is running
    RefundEscrow private _escrow;

    /**
     * @dev Constructor, creates RefundEscrow.
     * @param goal_ Funding goal
     */
    constructor(uint256 goal_) {
        require(goal_ > 0, "RefundableCrowdsale: goal is 0");
        _escrow = new RefundEscrow(wallet);
        _goal = goal_;
    }

    /**
     * @return minimum amount of funds to be raised in wei.
     */
    function goal() public view returns (uint256) {
        return _goal;
    }

    /**
     * @dev Investors can claim refunds here if crowdsale is unsuccessful.
     * @param refundee Whose refund will be claimed.
     */
    function claimRefund(address payable refundee) public {
        require(finalized(), "RefundableCrowdsale: not finalized");
        require(!goalReached(), "RefundableCrowdsale: goal reached");

        _escrow.withdraw(refundee);
    }

    /**
     * @dev Checks whether funding goal was reached.
     * @return Whether funding goal was reached
     */
    function goalReached() public view returns (bool) {
        return weiRaised() >= _goal;
    }

    /**
     * @dev Escrow finalization task, called when finalize() is called.
     */
    function _finalization() internal virtual override {
        if (goalReached()) {
            _escrow.close();
            _escrow.beneficiaryWithdraw();
        } else {
            _escrow.enableRefunds();
        }

        super._finalization();
    }

    /**
     * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
     */
    function _forwardFunds() internal virtual override {
        _escrow.deposit{value: msg.value}(_msgSender());
    }
}
