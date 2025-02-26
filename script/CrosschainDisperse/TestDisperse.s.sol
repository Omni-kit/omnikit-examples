// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Script} from "forge-std/Script.sol";
import {ISuperchainWETH} from "optimism-contracts/interfaces/L2/ISuperchainWETH.sol";

import {console2} from "forge-std/console2.sol";

contract TestDisperse is Script {
    address payable constant SUPERCHAIN_WETH_TOKEN =
        payable(0x4200000000000000000000000000000000000024);
    address public constant TARGET_CONTRACT =
        0xA9E61938002f56C5d81258dc20920c318E9c98d4;

    function run() external {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address user = vm.addr(privateKey);
        uint256 amountToTransfer = 5 ether; // Set required WETH amount
        console2.log("user", user);

        vm.startBroadcast(privateKey);

        ISuperchainWETH wethToken = ISuperchainWETH(SUPERCHAIN_WETH_TOKEN);

        // Wrap ETH to WETH if needed
        if (wethToken.balanceOf(user) < amountToTransfer) {
            uint256 amountNeeded = amountToTransfer - wethToken.balanceOf(user);
            wethToken.deposit{value: amountNeeded}();
            console2.log("Wrapped", amountNeeded, "ETH to WETH");
        }

        // Approve target contract to spend WETH
        wethToken.approve(TARGET_CONTRACT, amountToTransfer);
        // console2.log(
        //     "Approved",
        //     TARGET_CONTRACT,
        //     "to spend",
        //     amountToTransfer,
        //     "WETH"
        // );

        // Call the transfer function on target contract

        console2.log("Calling transferERC20TokensToSingleChain...");
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

        console2.log("Transfer successful");
        vm.stopBroadcast();
    }
}

// forge script script/TestDisperse.s.sol --fork-url http://localhost:9545 -vvv
