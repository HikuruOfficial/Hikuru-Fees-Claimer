# FeeClaimer Smart Contract

## Overview

The `FeeClaimer` contract is designed to manage fees, yield, and gas claims within a decentralized finance (DeFi) ecosystem. It leverages the `IBlast` interface to interact with external contracts for claiming yields and gas efficiently. The contract incorporates features such as fee deposit, fee claim, yield claim, and gas claim functionalities, alongside security measures like reentrancy guards to ensure safe and atomic operations.


![image](https://github.com/HikuruOfficial/Hikuru-Fees-Claimer/assets/132744928/edd90011-78ae-47b8-9ab7-13d0e623d6d0)

## Features

- **Fee Management**: Allows users to deposit fees and claim them back.
- **Yield and Gas Claim**: Integrates with the `IBlast` interface to claim yield and gas, offering flexibility in handling contract yields and operational costs.
- **Security**: Utilizes `ReentrancyGuard` from OpenZeppelin to prevent reentrancy attacks.
- **Ownership Control**: Includes ownership functionality to restrict certain actions to the contract owner.
- **Event Logging**: Emits events for deposits and claims, facilitating transparency and traceability.

## Setup

### Prerequisites

- Node.js and npm installed.
- Truffle or Hardhat for compilation and deployment.
- An Ethereum wallet with ETH for deployment and interaction.

### Installation

1. Clone the repository and navigate into it:

```shell
git clone <repository-url>
cd fee-claimer
```

2. Install dependencies:

```shell
npm install
```

3. Compile the contract:

Using Truffle:

```shell
truffle compile
```

Using Hardhat:

```shell
npx hardhat compile
```

### Deployment

Deploy the contract to your chosen network with Truffle or Hardhat, specifying the initial owner address in the constructor:

Using Truffle:

```shell
truffle migrate --network <your-network>
```

Using Hardhat:

```shell
npx hardhat run scripts/deploy.js --network <your-network>
```

## Usage

### Interacting with the Contract

You can interact with the contract using Truffle, Hardhat, or directly through a web interface like Etherscan or a DApp.

#### Depositing Fees

To deposit fees for a user:

```solidity
contract.deposit(userAddress, amount, {value: amount, from: senderAddress});
```

#### Claiming All Fees


To claim all fees for the caller:

```solidity
contract.claimAllFees({from: userAddress});
```

#### Enabling/Disabling Claims

To enable or disable claim functionality (owner only):

```solidity
contract.setClaimEnabled(true or false, {from: ownerAddress});
```

#### Claiming Yield and Gas (Owner Only)

To claim all yield or gas for the contract:

```solidity
contract.claimAllYield();
contract.claimMyContractsGas();
```

## Security Considerations

- Ensure the ownership is properly managed to prevent unauthorized access.
- Review and test for reentrancy attacks despite the use of `ReentrancyGuard`.
- Validate the integrity and security of the `IBlast` interface and its implementations.

## Testing

Tests can be written and run using Truffle or Hardhat to ensure contract functionalities work as expected under various conditions.

## License

This project is licensed under the MIT License.
