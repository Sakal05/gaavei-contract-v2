// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.17;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {ERC721Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";

contract LoyKobV3 is Initializable, UUPSUpgradeable, OwnableUpgradeable, ERC721Upgradeable {
    uint256 public jlom;
    uint256 _tokenIdCounter;

    function initialize() public initializer {
        __UUPSUpgradeable_init();
        __Ownable_init();
        __ERC721_init("NhBartSakal2", "NBS");
        jlom = 0;
        _tokenIdCounter = 0;
    }

    function incrementJlom() external onlyProxy {
        jlom += 1;
    }

    function safeMint(address to) external onlyProxy onlyOwner {
        uint256 _newToken = _tokenIdCounter + 1;
        _safeMint(to, _newToken);
        _tokenIdCounter = _newToken;
    }

    /// @dev Upgrades the implementation of the proxy to new address.
    function _authorizeUpgrade(address) internal override onlyOwner {}
}
