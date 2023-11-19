// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IFlashLoanReceiver} from "../src/FlashLoan.sol";

contract FlashLoanReceiver is IFlashLoanReceiver {
    receive() external payable {}

    function executeOperation(
        uint256 amount,
        uint256 fee,
        address initiator
    ) external {
        payable(msg.sender).transfer(amount + fee);
    }
}
