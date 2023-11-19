# FeFe

Use Foundry cheatcodes in Fe tests written in Fe.

- `src/FlashLoan.sol` implements a minimal ETH flash loan contract in Solidity.
- `src/FlashLoan.fe` implements the same contract in Fe.
- `test/FlashLoan.sol` tests both contracts using Solidity. It creates the Fe implementation from its raw bytecode.
- `test/FlashLoan.fe` tests the Fe implementation using Fe by deploying the test written in Fe from its raw bytecode.

The test written in Fe uses Foundry cheatcodes by reimplementing a subset of the `forge-std` `Vm` interface and calling the same hardcoded `HEVM_ADDRESS` as Foundry.
