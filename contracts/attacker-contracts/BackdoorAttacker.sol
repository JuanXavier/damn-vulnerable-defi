// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BackdoorAttacker {
    function proxyCreated(
        GnosisSafeProxy proxy,
        address _singleton,
        bytes calldata initializer,
        uint256 saltNonce
    ) external {}
}
