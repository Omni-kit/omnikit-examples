// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {CrossChainStateSync} from "omnikit/CrossChainStateSync.sol";

contract PrimaryCounter is CrossChainStateSync {
    uint256 public number;

    function setNumber(uint256 newNumber) public {
        number = newNumber;

        // Encode the function call and convert it to `bytes calldata`
        bytes memory message = abi.encodeCall(this.setNumber, (newNumber));

        // Convert the fixed-size array to a dynamic array of `uint256`
        uint256[] memory chainIds = new uint256[](1);
        chainIds[0] = 902;

        // Call `syncStates` with the correct types
        syncStates(message, chainIds);
    }

    function increment() public {
        number++;
    }
}
