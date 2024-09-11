// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.13;

// import {Script} from "forge-std/Script.sol";
// import {console} from "forge-std/Console.sol";
// import {Upgrades, Options} from "openzeppelin-foundry-upgrades/Upgrades.sol";
// import {Defender, ApprovalProcessResponse} from "openzeppelin-foundry-upgrades/Defender.sol";
// import {GaaveiDrop} from "../src/GaaveiDrop.sol";

// contract DeployDefender is Script {
//     function setup() public {}

//     function run() public {
//         Options memory opts;

//         opts.defender.useDefenderDeploy = true;
//         // opts.defender. = true;

//         address proxy = Upgrades.deployContract(
//             "GaaveiDrop.sol", abi.encodeCall(GaaveiDrop.initialize, ("arguments for the initialize function")), opts
//         );

//         console.log(proxy);
//     }
// }
