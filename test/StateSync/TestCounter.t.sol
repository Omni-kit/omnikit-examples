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

    // Fork IDs for chain A and chain B
    uint256 forkA;
    uint256 forkB;

    // Contract deployers and contract addresses
    ContractDeployer deployer901;
    ContractDeployer deployer902;
    address primaryCounter901;
    address counter902;

    // Setup function to initialize the test environment
    function setUp() public {
        // Salt for deterministic deployment
        bytes32 salt = keccak256(abi.encodePacked("counter"));

        // Create forks for chain A and chain B
        forkA = vm.createFork("http://127.0.0.1:9545"); // chainId 901
        forkB = vm.createFork("http://127.0.0.1:9546"); // chainId 902

        // Deploy PrimaryCounter on chain A
        vm.selectFork(forkA);
        deployer901 = new ContractDeployer{salt: "deployer"}();
        primaryCounter901 = deployer901.deploy(
            salt,
            type(PrimaryCounter).creationCode
        );

        // Deploy Counter on chain B
        vm.selectFork(forkB);
        deployer902 = new ContractDeployer{salt: "deployer"}();
        counter902 = deployer902.deploy(salt, type(Counter).creationCode);
    }

    // Test function to verify state synchronization between chains
    function testSyncStatesFunction() public {
        vm.selectFork(forkA);

        PrimaryCounter(primaryCounter901).setNumber(2);

        uint256 number901 = PrimaryCounter(primaryCounter901).number();
        console.log("number on 901 chain", number901);

        vm.selectFork(forkB);

        address messengerAddr = Predeploys.L2_TO_L2_CROSS_DOMAIN_MESSENGER;
        vm.prank(messengerAddr);

        // Mock the cross-domain messenger to simulate a cross-chain message
        vm.mockCall(
            messengerAddr,
            abi.encodeWithSelector(
                IL2ToL2CrossDomainMessenger.crossDomainMessageSender.selector
            ),
            abi.encode(counter902)
        );
        Counter(counter902).setNumber(2);

        uint256 number902 = Counter(counter902).number();
        console.log("number on 902 chain", number902);
    }

    // Test function to ensure only the cross-domain messenger can call the setNumber function
    function testOnlyCrossDomainCallbackCanCall() public {
        vm.selectFork(forkB);

        // Direct call fails
        vm.expectRevert(CallerNotL2ToL2CrossDomainMessenger.selector);
        Counter(counter902).setNumber(2);

        // Mock the cross-domain messenger to simulate a cross-chain message
        address messengerAddr = Predeploys.L2_TO_L2_CROSS_DOMAIN_MESSENGER;
        vm.prank(messengerAddr);
        vm.mockCall(
            messengerAddr,
            abi.encodeWithSelector(
                IL2ToL2CrossDomainMessenger.crossDomainMessageSender.selector
            ),
            abi.encode(address(0xdead))
        );

        vm.expectRevert(InvalidCrossDomainSender.selector);

        Counter(counter902).setNumber(2);
        vm.stopPrank();
    }
}
