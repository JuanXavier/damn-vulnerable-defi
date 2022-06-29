// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './TrustfulOracle.sol';

contract TrustfulOracleInitializer {
	event NewTrustfulOracle(address oracleAddress);

	TrustfulOracle public oracle;

	constructor(
		address[] memory sources,
		string[] memory symbols,
		uint256[] memory initialPrices
	) {
		oracle = new TrustfulOracle(sources, true);
		oracle.setupInitialPrices(sources, symbols, initialPrices);
		emit NewTrustfulOracle(address(oracle));
	}
}
