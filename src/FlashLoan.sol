// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IFlashLoanReceiver {
    function executeOperation(
        uint256 amount,
        uint256 fee,
        address initiator
    ) external;
}

contract FlashLoan {
    receive() external payable {}

    address public owner;
    uint256 public feePerMillion; // Fee per million (1e6 = 100%)

    event FlashLoanExecuted(address indexed borrower, uint256 amount);

    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "FlashLoan: Only owner");
        _;
    }

    function flashLoan(uint256 amount) external {
        uint256 balanceBefore = address(this).balance;
        require(balanceBefore >= amount, "FlashLoan: Insufficient liquidity");
        uint256 fee = (amount * feePerMillion) / 1e6;
        payable(msg.sender).transfer(amount);

        IFlashLoanReceiver(msg.sender).executeOperation(
            amount,
            fee,
            msg.sender
        );

        require(
            address(this).balance >= balanceBefore + fee,
            "FlashLoan: Loan not repaid with fee"
        );
        emit FlashLoanExecuted(msg.sender, amount);
    }

    function setOwner(address _owner) onlyOwner external {
        owner = _owner;
    }

    function setFeePerMillion(uint256 _feePerMillion) onlyOwner external {
        require(_feePerMillion <= 1e6, "FlashLoan: Fee too high");
        feePerMillion = _feePerMillion;
    }

    function withdraw(address recipient, uint256 amount) onlyOwner external {
        payable(recipient).transfer(amount);
    }
}
