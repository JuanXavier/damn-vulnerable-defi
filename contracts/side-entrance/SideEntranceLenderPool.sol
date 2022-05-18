// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Address.sol";

/*
ToDo:
A surprisingly simple lending pool allows anyone to deposit ETH, and withdraw 
it at any point in time.

This very simple lending pool has 1000 ETH in balance already, and is offering 
free flash loans using the deposited ETH to promote their system.

You must take all ETH from the lending pool.

Idea: 

-  Deposit Eth without having eth.

*/

interface IFlashLoanEtherReceiver {
    function execute() external payable;
}

contract SideEntranceLenderPool {
    using Address for address payable;

    mapping(address => uint256) private balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint256 amountToWithdraw = balances[msg.sender];
        balances[msg.sender] = 0;
        payable(msg.sender).sendValue(amountToWithdraw);
    }

    function flashLoan(uint256 amount) external {
        uint256 balanceBefore = address(this).balance;
        require(balanceBefore >= amount, "Not enough ETH in balance");

        IFlashLoanEtherReceiver(msg.sender).execute{value: amount}();

        require(
            address(this).balance >= balanceBefore,
            "Flash loan hasn't been paid back"
        );
    }
}
