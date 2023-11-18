SHELL := /bin/bash

.PHONY: sol fe build test

sol:
	forge build
	sh codegen.sh out/FlashLoan.sol/FlashLoan.json Solidity

fe:
	mkdir -p out/FlashLoan.fe
	fe build src/FlashLoan.fe -o .tmp --emit bytecode --overwrite
	jq -n --arg bytecode "$$(cat .tmp/FlashLoan/FlashLoan.bin)" '{"bytecode": {"object": ("0x" + $$bytecode)}}' > out/FlashLoan.fe/FlashLoan.json
	rm -rf .tmp
	sh codegen.sh out/FlashLoan.fe/FlashLoan.json Fe

build: sol fe
	forge build

test: build
	forge test --initial-balance 1000000000 -vv
