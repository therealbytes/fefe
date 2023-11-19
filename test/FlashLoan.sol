// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";

import {DeployedBytecode as SolidityBytecode} from "./bytecode/Solidity.sol";
import {DeployedBytecode as FeBytecode} from "./bytecode/Fe.sol";
import {FlashLoanReceiver} from "./utils.sol";

import {FlashLoan} from "../src/FlashLoan.sol";
import {DeployLib} from "../src/DeployLib.sol";

contract FlashLoanTest is Test {
    function setUp() public {}

    function testFlashLoanSolidity() public {
        console2.log("[Solidity]");
        console2.log("Creating FlashLoan contract");
        FlashLoan flashLoan = new FlashLoan();
        utilTestFlashLoan(flashLoan);
    }

    function testFlashLoanSolidityBytecode() public {
        console2.log("[Solidity bytecode]");
        console2.log("Creating FlashLoan contract");
        address payable addr = payable(DeployLib.create(SolidityBytecode));
        FlashLoan flashLoan = FlashLoan(addr);
        utilTestFlashLoan(flashLoan);
    }

    function testFlashLoanFeBytecode() public {
        console2.log("[Fe bytecode]");
        console2.log("Creating FlashLoan contract");
        address payable addr = payable(DeployLib.create(FeBytecode));
        FlashLoan flashLoan = FlashLoan(addr);
        utilTestFlashLoan(flashLoan);
    }

    function utilTestFlashLoan(FlashLoan flashLoan) public {
        uint256 feePerMillion = 1000;
        uint256 liquidity = 1000000;
        uint256 amount = 1000;

        console2.log("Setting fee");
        flashLoan.setFeePerMillion(feePerMillion);
        console2.log("Creating FlashLoanReceiver contract");
        FlashLoanReceiver flashLoanReceiver = new FlashLoanReceiver();

        console2.log("Funding FlashLoan contract");
        payable(address(flashLoan)).transfer(liquidity);
        console2.log("Funding FlashLoanReceiver contract");
        payable(address(flashLoanReceiver)).transfer(liquidity);

        console2.log("Executing flash loan");
        vm.prank(address(flashLoanReceiver));

        uint256 gasGasLeft = gasleft();
        flashLoan.flashLoan(amount);
        uint256 gasGasUsed = gasGasLeft - gasleft();
        console2.log("Gas used: %d", gasGasUsed);
        require(address(flashLoanReceiver).balance == liquidity - amount * feePerMillion / 1e6, "Incorrect balance");
        console2.log("Success.");
    }
}
