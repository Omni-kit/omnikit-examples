// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {CrossChainStateSync} from "omnikit/CrossChainStateSync.sol";

contract Counter is CrossChainStateSync {
    uint256 public number;

    function setNumber(uint256 newNumber) public onlyCrossDomainCallback {
        number = newNumber;
    }

    function increment() public {
        number++;
    }
}
