// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.17;

import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import {ERC1155Holder} from "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

// This contract is not audited. *-*

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract GaaveiStaker is ERC1155Holder, Ownable {
    IERC1155 public nftToken;
    IERC20 public rewardToken;
    mapping(uint256 => address) public tokenOwnerOf; // who's the owner of each tokenId
    mapping(uint256 => uint256) public tokenStakedAtTime; // time at which token was staked
    mapping(uint256 => uint256) public tokenAmountStaked; // how much amount of each tokenId is staked

    /// @notice Emitted when token is being staked
    /// @param tokenId tokenId that is staked
    /// @param amount the parameters of amount that is staked
    /// @param staker the parameters of staker
    event StakeNFT(uint256 indexed tokenId, uint256 amount, address staker);

    /// @notice Emitted when token is being unstaked
    /// @param tokenId tokenId that is staked
    /// @param amount the parameters of total amount after calculation with stake interest rate
    /// @param claimer the parameters of claimer
    event UnstakeNft(uint256 indexed tokenId, uint256 amount, address claimer);

    constructor(address _nftToken, address _rewardToken) {
        nftToken = IERC1155(_nftToken);
        rewardToken = IERC20(_rewardToken);
    }

    function stakeNFT(uint256 tokenId, uint256 amount) external {
        nftToken.safeTransferFrom(msg.sender, address(this), tokenId, amount, "0x"); // from, to, id, amount, data
        tokenOwnerOf[tokenId] = msg.sender;
        tokenStakedAtTime[tokenId] = block.timestamp;
        tokenAmountStaked[tokenId] = amount;
        emit StakeNFT(tokenId, amount, msg.sender);
    }

    function stakeBatchNFT(uint256[] memory tokenId, uint256[] memory amount) external {
        nftToken.safeBatchTransferFrom(msg.sender, address(this), tokenId, amount, "0x"); // from, to, id, amount, data
        for (uint256 i = 0; i < tokenId.length; i++) {
            tokenOwnerOf[tokenId[i]] = msg.sender;
            tokenStakedAtTime[tokenId[i]] = block.timestamp;
            tokenAmountStaked[tokenId[i]] = amount[i];
        }
    }

    function unstakeNFT(uint256 tokenId, uint256 amount) external {
        require(tokenOwnerOf[tokenId] == msg.sender);
        // _mint(msg.sender, );
        //address sender, address recipient, uint amount
        //transfer(address recipient, uint amount) external returns (bool);
        rewardToken.transfer(msg.sender, calculateTokens(tokenId)); // transferFrom(address(this), msg.sender, calculateTokens(tokenId));
        nftToken.safeTransferFrom(address(this), msg.sender, tokenId, amount, "0x");
        delete tokenOwnerOf[tokenId];
        delete tokenStakedAtTime[tokenId];
        emit UnstakeNft(tokenId, amount, msg.sender);
    }

    function unstakeBatchNFT(uint256[] memory tokenId, uint256[] memory amount) external {
        for (uint256 i = 0; i < tokenId.length; i++) {
            require(tokenOwnerOf[tokenId[i]] == msg.sender);
        }
        nftToken.safeBatchTransferFrom(address(this), msg.sender, tokenId, amount, "0x");
        for (uint256 i = 0; i < tokenId.length; i++) {
            // _mint(msg.sender, calculateTokens(tokenId[i]));
            IERC20(rewardToken).transferFrom(address(this), msg.sender, calculateTokens(tokenId[i]));
            delete tokenOwnerOf[tokenId[i]];
            delete tokenStakedAtTime[tokenId[i]];
        }
    }

    function calculateTokens(uint256 tokenId) public view returns (uint256) {
        require(tokenOwnerOf[tokenId] != address(0), "No token staked with given token ID");
        uint256 amount = tokenAmountStaked[tokenId];
        uint256 timeElapsed = block.timestamp - tokenStakedAtTime[tokenId];
        uint256 interestRate;
        if (timeElapsed <= 30 days) {
            interestRate = 5; // 5% interest rate for upto 1 month (30 days)
        } else if (timeElapsed <= 26 weeks) {
            interestRate = 10; // 10% interest rate for upto 6 months
        } else if (timeElapsed <= 52 weeks) {
            interestRate = 15; // 15% interest rate for upto 1 year (52 weeks)
        } else {
            interestRate = 18;
        } // 18% fixed interest rate after 1 year
        return (timeElapsed * interestRate) * (amount) * (10 ** 18) / 100; // ERC20: 1 token = 10^18 subtokens
    }
}
