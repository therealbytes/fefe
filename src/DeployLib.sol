// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

library DeployLib {
    function create(bytes memory code) internal returns (address) {
        address newContract;
        assembly {
            newContract := create(0, add(code, 0x20), mload(code))
        }
        require(newContract != address(0), "DeployLib: Failed to deploy contract");
        return newContract;
    }
}
