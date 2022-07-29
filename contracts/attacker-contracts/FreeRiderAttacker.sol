// // SPDX-License-Identifier: MIT
// pragma solidity ^0.6.6;

// import "../free-rider/FreeRiderNFTMarketplace.sol";
// import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
// import "@uniswap/v2-periphery/contracts/libraries/UniswapV2Library.sol";

// contract FreeRiderAttacker {
//     IERC721 private immutable nfts;
//     FreeRiderNFTMarketplace private immutable marketplace;
//     address immutable owner;

//     constructor(address payable _marketplaceAddr, address payable _nfts)
//         payable
//     {
//         marketplace = FreeRiderNFTMarketplace(_marketplaceAddr);
//         owner = msg.sender;
//         nfts = IERC721(_nfts);
//     }

//     function attack() external payable {
//         require(msg.sender == owner);
//         // marketplace.buyMany([0, 1, 2, 3, 4, 5]);
//     }

//     // Do .... when receiving an nft
//     // same 15 ETH FOR ALL TX
//     function onERC721Received(
//         address,
//         address,
//         uint256 _tokenId,
//         bytes memory
//     ) external returns (bytes4) {
//         require(msg.sender == address(marketplace));

//         // return IERC721Receiver.onERC721Received.selector;
//         return 0x150b7a02;
//     }

//     function _getOracleQuote(uint256 amount) private view returns (uint256) {
//         (uint256 reservesWETH, uint256 reservesToken) = UniswapV2Library
//             .getReserves(_uniswapFactory, address(_weth), address(_token));
//         return
//             UniswapV2Library.quote(
//                 amount.mul(10**18),
//                 reservesToken,
//                 reservesWETH
//             );
//     }
// }
