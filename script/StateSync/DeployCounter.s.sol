// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {PrimaryCounter} from "../../src/StateSync-Example/PrimaryCounter.sol";
import {Counter} from "../../src/StateSync-Example/Counter.sol";
import {ContractDeployer} from "../../src/ContractDeployer.sol";

contract DeployCounterScript is Script {
    bytes32 salt = keccak256(abi.encodePacked("counter"));

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

        bytes memory counterCreationCode = type(Counter).creationCode;
        bytes memory primaryCounterCreationCode = type(PrimaryCounter)
            .creationCode;

        // Deploy on Chain 1 (OPChainA).
        vm.selectFork(fork1);
        vm.startBroadcast(deployerPrivateKey);

        ContractDeployer deployer1 = new ContractDeployer{salt: "deployer"}();
        address counter = deployer1.deploy(salt, counterCreationCode);

        vm.stopBroadcast();

        console.log("Counter contract deployed at:", counter);

        // Deploy on Chain 2 (OPChainB).
        vm.selectFork(fork2);
        vm.startBroadcast(deployerPrivateKey);

        ContractDeployer deployer2 = new ContractDeployer{salt: "deployer"}();
        address primaryCounter = deployer2.deploy(
            salt,
            primaryCounterCreationCode
        );

        vm.stopBroadcast();

        console.log("PrimaryCounter contract deployed at:", primaryCounter);
    }
}
