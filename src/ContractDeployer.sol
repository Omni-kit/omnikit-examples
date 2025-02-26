// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "solady/utils/CREATE3.sol";

contract ContractDeployer {
    // Public function to deploy the contract deterministically
    function deploy(
        bytes32 salt,
        bytes memory creationCode
    ) external returns (address deployed) {
        // Deploy the contract deterministically with a salt and creation code
        deployed = _deployDeterministic(0, creationCode, salt);
    }

    // Internal wrapper to expose the internal CREATE3 function
    function _deployDeterministic(
        uint256 value,
        bytes memory initCode,
        bytes32 salt
    ) internal returns (address deployed) {
        // Use the internal deployDeterministic function from CREATE3
        deployed = CREATE3.deployDeterministic(value, initCode, salt);
    }

    // Public function to get the address of a deployed contract deterministically
    function getDeployedAddress(bytes32 salt) external view returns (address) {
        // Return the deterministic address based on the salt
        return CREATE3.predictDeterministicAddress(salt);
    }
}
