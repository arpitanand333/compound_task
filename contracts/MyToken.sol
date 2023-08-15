// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

interface ICERC20 {
    function mint(uint256 amount) external returns (uint256);

    function redeemUnderlying(uint256 amount) external returns (uint256);

    function balanceOfUnderlying(address owner) external returns (uint256);
}



contract MyToken is ERC721, ERC721Burnable, Ownable {
    // Compound token address
    address public cERC20;
    // Stable coin address(Dai/USDC)
    address public undelyingAsset;
    //Price to get NFT
    uint256 public tokenPrice = 100 * 10 ** 6;
    uint256 public tokenIdCounter;
    // Track number of active users deposited Stable coin and minted NFT.  
    uint256 public totalActiveSupply;

    
    event UnderlyingBalance(uint256 indexed balance);
   
    /**
     * @param _cERC20 Address of the Compound cToken address.
     * @param _undelyingAsset Address of the Stable coin(Dai/USDC).
     */
    constructor(address _cERC20, address _undelyingAsset)
        ERC721("MyToken", "MTK")
    {
        cERC20 = _cERC20;
        undelyingAsset = _undelyingAsset;
        IERC20(_undelyingAsset).approve(_cERC20, type(uint256).max);
    }
    /**
     * @dev Any user can mint Nft after deposit
     * Only 100 Dai token.
     * @param to Address to mint NFT.
     */
    function safeMint(address to) public {
        require(
            IERC20(undelyingAsset).allowance(msg.sender, address(this)) >=
                tokenPrice,
            "Insufficient Allowance Of Undelying Asset To Contract"
        );
        IERC20(undelyingAsset).transferFrom(
            msg.sender,
            address(this),
            tokenPrice
        );
        ICERC20(cERC20).mint(tokenPrice); 
        totalActiveSupply++;
        _safeMint(to, ++tokenIdCounter);
    }
    /**
     * @dev  user can burn Nft and get back 
     * their deposited stable coin back.
     * @param tokenId  NFT token id .
     */
    function burn(uint256 tokenId) public override {
        require(
            ownerOf(tokenId) == msg.sender,
            "Only Token Owner Can Burn Token"
        );
        ICERC20(cERC20).redeemUnderlying(tokenPrice);
        IERC20(undelyingAsset).transfer(msg.sender, tokenPrice);
        totalActiveSupply--;
        _burn(tokenId);
    }
    // To get balance of cToken 
    function getUnderlyingBalance() external onlyOwner {
        uint256 balance = ICERC20(cERC20).balanceOfUnderlying(
            address(this)
        );
        emit UnderlyingBalance(balance);
    }
    /**
     * @notice Only Admin can withdraw interest anytime.
     */
    function redeemInterestsOnFunds() external onlyOwner {
        uint256 underlyingBalance = ICERC20(cERC20).balanceOfUnderlying(
            address(this)
        );
        uint256 totalFundsOfUsers = totalActiveSupply * tokenPrice;
        require(
            underlyingBalance > totalFundsOfUsers,
            "No Interest To Be Claim"
        );
        uint256 interestOnFunds = underlyingBalance - totalFundsOfUsers;
        ICERC20(cERC20).redeemUnderlying(interestOnFunds);
        IERC20(undelyingAsset).transfer(owner(), interestOnFunds);
    }
}