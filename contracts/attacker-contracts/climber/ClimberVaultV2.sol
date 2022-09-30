// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import { OwnableUpgradeable, UUPSUpgradeable, IERC20 } from "../../climber/ClimberVault.sol";

contract ClimberVaultV2 is OwnableUpgradeable, UUPSUpgradeable {
    uint256 public constant WITHDRAWAL_LIMIT = 1 ether;
    uint256 public constant WAITING_PERIOD = 15 days;
    uint256 private _lastWithdrawalTimestamp;
    address private _sweeper;

    function sweepFunds(address tokenAddress) external onlyOwner {
        IERC20 token = IERC20(tokenAddress);
        require(token.transfer(msg.sender, token.balanceOf(address(this))), "Transfer failed");
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
