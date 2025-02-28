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

        // Define configurations for two chains.
        ChainConfig[] memory chains = new ChainConfig[](2);
        chains[0] = ChainConfig(901, "http://127.0.0.1:9545"); // Hub's chain (source)
        chains[1] = ChainConfig(902, "http://127.0.0.1:9546"); // Spoke's chain (destination)

        // Create persistent forks for each chain.
        uint256 forkHub = vm.createFork(chains[0].rpcUrl);
        uint256 forkSpoke = vm.createFork(chains[1].rpcUrl);

        // Get creation codes.
        bytes memory hubCreationCode = type(Hub).creationCode;

        uint256 _hubChainId = chains[0].chainId;
        bytes memory spokeCreationCode = abi.encodePacked(
            type(Spoke).creationCode,
            abi.encode(_hubChainId)
        );
        // ------------------------------------
        // Deploy Hub on Chain 901 (source chain)
        vm.selectFork(forkHub);
        vm.startBroadcast(deployerPrivateKey);
        ContractDeployer hubDeployer = new ContractDeployer{salt: "deployer"}();
        address hubAddress = hubDeployer.deploy(salt, hubCreationCode);

        vm.stopBroadcast();
        console.log("Hub deployed at:", hubAddress);

        // ------------------------------------
        // Deploy Spoke on Chain 902 (destination chain)
        vm.selectFork(forkSpoke);
        vm.startBroadcast(deployerPrivateKey);
        ContractDeployer spokeDeployer = new ContractDeployer{
            salt: "deployer"
        }();
        address spokeAddress = spokeDeployer.deploy(salt, spokeCreationCode);
        vm.stopBroadcast();
        console.log("Spoke deployed at:", spokeAddress);

        
    }
}
