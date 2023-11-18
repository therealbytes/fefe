.PHONY: build test

build:
	forge build
	sh codegen.sh out/FlashLoan.sol/FlashLoan.json Solidity
	# sh codegen.sh out/FlashLoan.sol/FlashLoan.json Fe
	forge build

test: build
	forge test --initial-balance 1000000000 -vv
