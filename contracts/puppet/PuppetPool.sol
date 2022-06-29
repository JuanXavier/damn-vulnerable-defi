// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "../DamnValuableToken.sol";

/**
 * @title PuppetPool
 * @author Damn Vulnerable DeFi (https://damnvulnerabledefi.xyz)
 */
contract PuppetPool is ReentrancyGuard {
    using Address for address payable;

    mapping(address => uint256) public deposits;
    address public immutable uniswapPair;
    DamnValuableToken public immutable token;

    event Borrowed(
        address indexed account,
        uint256 depositRequired,
        uint256 borrowAmount
    );

    constructor(address tokenAddress, address uniswapPairAddress) {
        token = DamnValuableToken(tokenAddress);
        uniswapPair = uniswapPairAddress;
    }

    // Allows borrowing `borrowAmount` of tokens by first depositing two times their value in ETH
    function borrow(uint256 borrowAmount) public payable nonReentrant {
        uint256 depositRequired = calculateDepositRequired(borrowAmount);
        require(
            msg.value >= depositRequired,
            "Not depositing enough collateral"
        );

        if (msg.value > depositRequired) {
            payable(msg.sender).sendValue(msg.value - depositRequired);
        }
        deposits[msg.sender] = deposits[msg.sender] + depositRequired;

        // Fails if the pool doesn't have enough tokens in liquidity
        require(token.transfer(msg.sender, borrowAmount), "Transfer failed");
        emit Borrowed(msg.sender, depositRequired, borrowAmount);
    }

    function calculateDepositRequired(uint256 amount)
        public
        view
        returns (uint256)
    {
        return (amount * _computeOraclePrice() * 2) / 10**18;
    }

    function _computeOraclePrice() private view returns (uint256) {
        // calculates the price of the token in wei according to Uniswap pair
        return (uniswapPair.balance * (10**18)) / token.balanceOf(uniswapPair);
    }

    /**
     ... functions to deposit, redeem, repay, calculate interest, and so on ...

        precio = balance en ether / balance en token

        0.
            Pool =           100000 DVT
            Uniswap =     10 ETH => 10 DVT = PRECIO = 1
            Me =              25 ETH => 1000 DVT
            
        1 . enviar 1000 tokens al exchange

            Pool =           100000 DVT
            Uniswap =     10 ETH => 1010 DVT = PRECIO = 0.009
            Me =              25 ETH => 0 DVT

        2. Pedir prestado

		num= DEPOSITED_TOKENS + ETH_RESERVE
		den= TOTAL_TOKENS + DEPOSITED_TOKENS
		
		num = 1000 DVT * 10 ETH
		den = 10 DVT + 1000 DVT
		RESULT = 

	*/
}
