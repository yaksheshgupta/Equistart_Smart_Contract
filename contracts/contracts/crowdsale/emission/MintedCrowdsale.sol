// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../Crowdsale.sol";
import "../utils/tkn/ERC20Mintable.sol";
// import "../../ERC20Token.sol" ;

/**
 * @title MintedCrowdsale
 * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
 * Token ownership should be transferred to MintedCrowdsale for minting.
 */
abstract contract MintedCrowdsale is Crowdsale {


    /**
     * @dev Overrides delivery by minting tokens upon purchase.
     * @param beneficiary Token purchaser
     * @param tokenAmount Number of tokens to be minted
     */
    function _deliverTokens(address beneficiary, uint256 tokenAmount)
        internal
        virtual
        override
    {
        // Potentially dangerous assumption about the type of the token.
        require(
            ERC20Mintable(address(token)).mint(beneficiary, tokenAmount),
            "MintedCrowdsale: minting failed"
        );
    }
}
