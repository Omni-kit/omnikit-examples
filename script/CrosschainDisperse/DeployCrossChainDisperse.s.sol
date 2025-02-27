// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import {CrossChainDisperse} from "../../src/Interop-Example/CrossChainDisperse.sol";

contract DeployCrossChainDisperse is Script {
    struct ChainConfig {
        uint256 chainId;
        string rpcUrl;
    }

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // Define configurations for two chains.
        ChainConfig[] memory chains = new ChainConfig[](2);
        chains[0] = ChainConfig(901, "http://127.0.0.1:9545"); // OPChainA
        chains[1] = ChainConfig(902, "http://127.0.0.1:9546"); // OPChainB

        // Create persistent forks for each chain.
        uint256 fork1 = vm.createFork(chains[0].rpcUrl);
        uint256 fork2 = vm.createFork(chains[1].rpcUrl);

        // Deploy on Chain 1 (OPChainA).
        vm.selectFork(fork1);
        vm.startBroadcast(deployerPrivateKey);

        CrossChainDisperse disperse901 = new CrossChainDisperse{
            salt: "SmartDisperse"
        }();
        console.log("deploying in 901...");
        console.log(
            "SmartDisperse contract deployed at:",
            address(disperse901)
        );
        vm.stopBroadcast();

        // Deploy on Chain 2 (OPChainB).
        vm.selectFork(fork2);
        vm.startBroadcast(deployerPrivateKey);

        CrossChainDisperse disperse902 = new CrossChainDisperse{
            salt: "SmartDisperse"
        }();
        console.log("deploying in 902...");
        console.log(
            "SmartDisperse contract deployed at:",
            address(disperse902)
        );

        vm.stopBroadcast();
    }
}
