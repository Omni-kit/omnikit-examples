// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {CrossChainUtils} from "omnikit/libraries/CrossChainUtils.sol";

contract Hub {
    uint256 public data;
    event DataUpdated(uint256 newValue);

    /**
     * @notice Example function to update data (restricted to cross-chain calls).
     * @param newValue The new value to store.
     */
    function updateData(uint256 newValue) external {
        // Validate that the call came through the correct cross-chain messenger
        CrossChainUtils.validateCrossDomainCallback();

        data = newValue;
        emit DataUpdated(newValue);
    }

    /**
     * @notice Another example function that can be called via cross-chain message.
     * @param x An example parameter.
     * @param y Another example parameter.
     */
    function someOtherFunction(uint256 x, address y) external {
        CrossChainUtils.validateCrossDomainCallback();

        // Example logic
        data = x;
        // do something with y...
    }

    // You can add as many cross-chain callable functions here as you like,
    // all protected by CrossChainUtils.validateCrossDomainCallback().
}
