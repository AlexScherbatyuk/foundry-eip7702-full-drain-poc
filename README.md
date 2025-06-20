# EIP-7702 Wallet Full Drain Proof-of-Concept

**A demonstration of a critical vulnerability in EIP-7702 delegated transactions that allows complete wallet draining**

## Overview

This repository contains a proof-of-concept demonstrating a severe security vulnerability in EIP-7702's delegated transaction mechanism. The vulnerability allows an attacker to completely drain a victim's wallet by exploiting the delegation signature verification process.

## EIP-7702 Background

EIP-7702 introduces key features for account abstraction and delegated transactions:

### Core Features
- **Delegated Transactions**: Allows EOAs to delegate transaction signing rights to smart contracts
- **Signature Verification**: Contracts can verify EOA signatures to authorize operations
- **Gas Payment Flexibility**: Enables alternative gas payment methods beyond standard EOA payments
- **Prague Hard Fork**: Part of the Prague hard fork, enabling new transaction types

### Technical Details
- **Delegation Signatures**: EOAs can sign delegation messages that allow other addresses to execute transactions on their behalf
- **Signature Verification**: Smart contracts can verify these signatures using `vm.signAndAttachDelegation()` and `vm.attachDelegation()`
- **Transaction Execution**: Delegated transactions can be executed by any address that possesses a valid delegation signature

## The Full Drain Vulnerability

### Vulnerability Description
The proof-of-concept demonstrates how an attacker can exploit EIP-7702's delegation mechanism to completely drain a victim's wallet. The attack works by:

1. **Obtaining Delegation Signature**: The attacker somehow obtains a valid delegation signature from the victim
2. **Exploiting Contract Logic**: Using the delegation to execute malicious contract functions
3. **Complete Asset Drain**: Transferring all tokens and assets to the attacker's address

### Attack Vector
The `EOABackdoor` contract demonstrates this vulnerability:

```solidity
function increment() public {
    i_tokenA.transfer(EEEVVVILLL, i_tokenA.balanceOf(address(this)));
    i_tokenB.transfer(EEEVVVILLL, i_tokenB.balanceOf(address(this)));
    i_tokenC.transfer(EEEVVVILLL, i_tokenC.balanceOf(address(this)));
}
```

When called with a valid delegation signature, this function transfers ALL tokens from the victim's address to the attacker's address (`EEEVVVILLL`).

### Test Scenarios
The repository includes two test scenarios:

1. **Single Transaction Attack**: Demonstrates the drain in a single transaction
2. **Multi-Transaction Attack**: Shows how the attack can be executed across multiple transactions

## Project Structure

```
├── src/
│   ├── EOABackdoor.sol      # Malicious contract demonstrating the vulnerability
│   └── MockToken.sol        # ERC20 token for testing
├── test/
│   └── EOABackdoorTest.t.sol # Test cases demonstrating the attack
├── foundry.toml             # Foundry configuration
└── README.md               # This file
```

## Prerequisites

- [Foundry](https://getfoundry.sh/) installed
- Solidity ^0.8.20
- OpenZeppelin Contracts library

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd foundry-eip7702-full-drain-poc
```

2. Install dependencies:
```bash
forge install
```

## Usage

### Build the Project

```bash
forge build
```

This will compile all contracts and generate artifacts in the `out/` directory.

### Run Tests

```bash
forge test
```

This will execute the test suite demonstrating the vulnerability.

### Run Specific Tests

```bash
# Run a specific test function
forge test --match-test testBackdoorOneTx

# Run with verbose output
forge test -vvv

# Run with gas reporting
forge test --gas-report
```

### Deploy Contracts (for testing)

```bash
# Deploy to local Anvil instance
anvil
forge script script/Deploy.s --rpc-url http://localhost:8545 --broadcast
```

## Security Implications

### Critical Risks
- **Complete Asset Loss**: Attackers can drain all tokens from victim wallets
- **Signature Reuse**: Delegation signatures can be reused multiple times
- **No Recovery Mechanism**: Once executed, the drain is irreversible

### Mitigation Strategies
- **Limited Delegation Scope**: Only delegate specific functions, not entire wallets
- **Time-Limited Delegations**: Use expiration timestamps on delegation signatures
- **Multi-Signature Requirements**: Require multiple signatures for high-value operations
- **Audit Delegation Contracts**: Thoroughly audit any contract that accepts delegations

## Technical Details

### Foundry Configuration
The project uses Foundry with the following key settings:
- **EVM Version**: Prague (required for EIP-7702)
- **EOA Support**: Enabled for delegation testing
- **OpenZeppelin**: Latest contracts for ERC20 implementation

### Key Addresses
- **Attacker Address**: `0x70997970C51812dc3A010C7d01b50e0d17dc79C8`
- **Victim Address**: `0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266`
- **Secondary Address**: `0xa0Ee7A142d267C1f36714E4a8F75612F20a79720`

## Contributing

This is a security research project. Please use responsibly and only on test networks or your own development environments.

## License

MIT License - See LICENSE file for details.

## Documentation

- [EIP-7702 Specification](https://eips.ethereum.org/EIPS/eip-7702)
- [Foundry Documentation](https://book.getfoundry.sh/)
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)
