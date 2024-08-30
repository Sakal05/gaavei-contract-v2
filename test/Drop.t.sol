// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {GaaveiDrop} from "../src/GaaveiDrop.sol";

contract DropTest is Test {
    GaaveiDrop public dropContract;
    address public deployer;

    function setUp() public {
        deployer = address(this);
        string memory name = "Go Go";

        string memory _symbol = "GG";
        address _royaltyRecipient = 0x33b6Cc6169a2Acea65b89DDD886125e04BE49CF6;
        uint128 _royaltyBps = 1000;
        dropContract = new GaaveiDrop(name, _symbol, _royaltyRecipient, _royaltyBps);
    }

    function getMappingValue(address targetContract, uint256 mapSlot, uint256 key) public view returns (uint256) {
        bytes32 slotValue = vm.load(targetContract, keccak256(abi.encode(key, mapSlot)));
        return uint256(slotValue);
    }

    function test_setClaimRestriction() public {
        vm.prank(deployer);
        uint256 tokenId = 1;
        bool resetClaimEligibility = false;

        GaaveiDrop.ClaimRestriction memory claimRestriction = GaaveiDrop.ClaimRestriction({
            startTimestamp: block.timestamp,
            maxSupply: 10,
            supplyClaimed: 0,
            quantityLimit: 10,
            price: 1 ether
        });
        vm.expectEmit(true, true, true, true); // Expecting the event with indexing
        emit GaaveiDrop.ClaimRestrictionUpdated(tokenId, claimRestriction, resetClaimEligibility);

        dropContract.setClaimRestriction(tokenId, claimRestriction, resetClaimEligibility);

        // Check storage values
        // uint256 storedStartTimestamp = getMappingValue(address(dropContract), 0, tokenId);
        // uint256 storedQuantityLimit = getMappingValue(address(dropContract), 3, tokenId); // adjust if necessary

        // // Add other fields if necessary, like maxSupply, supplyClaimed, etc.

        // console2.log(storedStartTimestamp);
        // console2.log(storedQuantityLimit);
        // assertEq(restriction.startTimestamp, claimRestriction.startTimestamp);
        // assertEq(restriction.maxSupply, claimRestriction.maxSupply);
        // assertEq(restriction.supplyClaimed, claimRestriction.supplyClaimed);
        // assertEq(restriction.quantityLimit, claimRestriction.quantityLimit);
        // assertEq(restriction.price, claimRestriction.price);
    }
}
