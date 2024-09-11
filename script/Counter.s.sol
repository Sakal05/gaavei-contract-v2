// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {LoyKobV3} from "../src/LoyKob.sol"; // Assuming you have the implementation contract as a source;

contract CounterScript is Script {
    address _proxyAddress = 0x6041B4C28E7792e16e846aC374Fa662e9cdA9F62;

    function setUp() public {}

    function run() public {
        vm.startBroadcast(); // Start broadcasting transaction

        // Create an instance of the proxy contract
        LoyKobV3 counter = LoyKobV3(_proxyAddress);

        // Test mint leng mer

        // Call the increment function (or any other function you'd like to test)
        // counter.increment();
        // counter.incrementJlom();
        // console.log("Increment Jlom called on proxy contract");

        // Optional: Fetch and log the current counter value
        address owner = counter.owner();
        console.log("Owner of contract: ", owner);
        string memory name = counter.name();
        console.log("Current ERC721 name:", name);

        vm.stopBroadcast(); // Stop broadcasting transaction
    }
}
