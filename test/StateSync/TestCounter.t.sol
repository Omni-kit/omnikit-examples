// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import "../../src/StateSync-Example/PrimaryCounter.sol";
import "../../src/StateSync-Example/Counter.sol";
import "../../src/ContractDeployer.sol";
import {IL2ToL2CrossDomainMessenger} from "optimism-contracts/interfaces/L2/IL2ToL2CrossDomainMessenger.sol";
import {Predeploys} from "optimism-contracts/src/libraries/Predeploys.sol";

contract TestCounter is Test {
    error CallerNotL2ToL2CrossDomainMessenger();
    error InvalidCrossDomainSender();

    uint256 forkA;
    uint256 forkB;
    ContractDeployer deployer901;
    ContractDeployer deployer902;
    address primaryCounter901;
    address counter902;

    function setUp() public {
        bytes32 salt = keccak256(abi.encodePacked("counter"));

        // Create forks for chain A and chain B
        forkA = vm.createFork("http://127.0.0.1:9545"); // chainId 901
        forkB = vm.createFork("http://127.0.0.1:9546"); // chainId 902

        vm.selectFork(forkA);
        deployer901 = new ContractDeployer{salt: "deployer"}();
        primaryCounter901 = deployer901.deploy(
            salt,
            type(PrimaryCounter).creationCode
        );

        vm.selectFork(forkB);
        deployer902 = new ContractDeployer{salt: "deployer"}();
        counter902 = deployer902.deploy(salt, type(Counter).creationCode);
    }

    function testDeployment() public view {
        console.log("primary counter...", primaryCounter901);
        console.log("counter...", counter902);
    }
}
