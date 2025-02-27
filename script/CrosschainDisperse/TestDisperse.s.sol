// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Script} from "forge-std/Script.sol";
import {ISuperchainWETH} from "optimism-contracts/interfaces/L2/ISuperchainWETH.sol";
import {console2} from "forge-std/console2.sol";

contract TestDisperse is Script {
    address payable constant SUPERCHAIN_WETH_TOKEN =
        payable(0x4200000000000000000000000000000000000024);
    address constant TARGET_CONTRACT =
        0xA9E61938002f56C5d81258dc20920c318E9c98d4;

    function run() external {
        ISuperchainWETH wethToken = ISuperchainWETH(SUPERCHAIN_WETH_TOKEN);

        uint256 fork1 = vm.createFork("http://127.0.0.1:9545");
        uint256 fork2 = vm.createFork("http://127.0.0.1:9546");

        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address user = vm.addr(privateKey);

        address[] memory recipients = new address[](2);
        recipients[0] = 0x90F79bf6EB2c4f870365E785982E1f101E93b906;
        recipients[1] = 0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65;

        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 2 ether;
        amounts[1] = 3 ether;

        vm.selectFork(fork1);
        vm.startBroadcast(privateKey);

        uint256 totalAmount = amounts[0] + amounts[1];

        if (wethToken.balanceOf(user) < totalAmount) {
            wethToken.deposit{value: totalAmount - wethToken.balanceOf(user)}();
        }
        wethToken.approve(TARGET_CONTRACT, totalAmount);

        (bool success, ) = TARGET_CONTRACT.call(
            abi.encodeWithSignature(
                "transferERC20TokensToSingleChain(address,uint256,address[],uint256[])",
                SUPERCHAIN_WETH_TOKEN,
                902,
                recipients,
                amounts
            )
        );
        require(success, "Transfer failed");
        vm.stopBroadcast();

        vm.selectFork(fork2);

        console2.log("after transfer...");

        console2.log(
            "Recipient 0 Balance:",
            wethToken.balanceOf(recipients[0])
        );
        console2.log(
            "Recipient 1 Balance:",
            wethToken.balanceOf(recipients[1])
        );
    }
}
