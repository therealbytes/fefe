// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";

import {DeployedBytecode as FeTestBytecode} from "./bytecode/FeTest.sol";
import {DeployedBytecode as FeBytecode} from "./bytecode/Fe.sol";
import {FlashLoanReceiver} from "./utils.sol";

import {FlashLoan} from "../src/FlashLoan.sol";
import {DeployLib} from "../src/DeployLib.sol";

interface IFlashLoanFeTest {
    function test(address loanAddr, address receiver) external;
}

contract FlashLoanTest is Test {
    function setUp() public {}

    function testFlashLoanTest() public {
        console2.log("[Fe test of Fe bytecode]");

        console2.log("Creating FlashLoanTest contract");
        address payable flashLoanTestAddr = payable(
            DeployLib.create(FeTestBytecode)
        );
        IFlashLoanFeTest flashLoanTest = IFlashLoanFeTest(flashLoanTestAddr);

        console2.log("Creating FlashLoan contract");
        address payable flashLoanAddr = payable(DeployLib.create(FeBytecode));
        FlashLoan flashLoan = FlashLoan(flashLoanAddr);

        console2.log("Creating FlashLoanReceiver contract");
        FlashLoanReceiver flashLoanReceiver = new FlashLoanReceiver();
        address payable receiverAddr = payable(address(flashLoanReceiver));

        console2.log("Funding FlashLoanTest contract");
        flashLoanTestAddr.transfer(100000000);
        flashLoan.setOwner(flashLoanTestAddr);

        console2.log("Executing flash loan test");
        flashLoanTest.test(flashLoanAddr, receiverAddr);
        require(receiverAddr.balance == 999999, "Incorrect balance");
        console2.log("Success.");
    }
}
