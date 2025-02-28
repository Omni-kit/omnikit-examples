// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Hub} from "../../src/Hub_Spoke-Example/Hub.sol";
import {Spoke} from "omnikit/Spoke.sol";
import {ContractDeployer} from "../../src/ContractDeployer.sol";

contract DeployHubAndSpokeScript is Script {
    bytes32 salt = keccak256(abi.encodePacked("hubspoke"));

    // Chain configuration structure.
    struct ChainConfig {
        uint256 chainId;
        string rpcUrl;
    }

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        address SPOKE = 0x136f21FA407Ee1A33eB8873A4f897CD922014062;
        address HUB = 0x136f21FA407Ee1A33eB8873A4f897CD922014062;

        // Define configurations for two chains.
        ChainConfig[] memory chains = new ChainConfig[](2);
        chains[0] = ChainConfig(901, "http://127.0.0.1:9545"); // Hub's chain (source)
        chains[1] = ChainConfig(902, "http://127.0.0.1:9546"); // Spoke's chain (destination)

        // Create persistent forks for each chain.
        uint256 forkHub = vm.createFork(chains[0].rpcUrl);
        uint256 forkSpoke = vm.createFork(chains[1].rpcUrl);

        bytes memory hubCallData = abi.encodeCall(Hub.updateData, (42));

        vm.selectFork(forkSpoke);
        vm.startBroadcast(deployerPrivateKey);

        Spoke spoke = Spoke(SPOKE);

        spoke.callAnyHubFunction(hubCallData);

        vm.stopBroadcast();
        console.log(
            "Spoke called callAnyHubFunction to trigger Hub.updateData(42)"
        );

        // ------------------------------------
        // Verify that Hub's state is updated.

        vm.selectFork(forkHub);
        Hub hub = Hub(HUB);

        uint256 updatedData = hub.data();

        console.log("Hub data after update:", updatedData);
    }
}

