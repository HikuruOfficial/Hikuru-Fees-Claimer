# FeeClaimer Smart Contract

![image](https://github.com/HikuruOfficial/Hikuru-Fees-Claimer/assets/132744928/32abf653-0974-4d3f-80cc-502a4c34af54)


The concept of the "Hikuru Fees Claimer" is essentially a rewards mechanism embedded within a broader ecosystem, likely involving a variety of online services such as domain registration, digital passport issuance, quest creation, and token exchange. This system is designed to incentivize and reward users who contribute to the growth and engagement of the platform through referrals. Below is an expanded explanation of the Hikuru Fees Claimer, breaking down its components and implications for users and the platform.

### Purpose and Functionality

- **Incentive for Referrals:** The primary purpose of the Hikuru Fees Claimer is to serve as an incentive for users to bring new participants into the ecosystem. By establishing a direct reward system for referrals, the platform encourages its users to promote its services actively.

- **Revenue Sharing Model:** The Hikuru Fees Claimer operates on a revenue-sharing model where 50% of the profits generated from commissions on various services provided by the platform are allocated to users with active referrals. This model demonstrates a commitment to sharing financial success with the community that contributes to the platform's growth.

- **Broad Applicability:** The scheme covers a wide range of services, including but not limited to buying a domain, acquiring a digital passport, creating quests, and exchanging tokens. This broad applicability ensures that users can earn rewards from multiple activities, making the referral program more attractive.

### Benefits for Users and the Platform

- **Support for the Community:** By distributing a portion of its profits back to the users, the platform not only rewards individual efforts but also supports the overall community. This approach can enhance user loyalty and foster a supportive ecosystem where users benefit directly from the platform's success.

- **Increased Platform Engagement:** The incentive structure is likely to motivate users to engage more deeply with the platform's offerings and explore services they might not have otherwise used, thereby increasing overall platform engagement.

- **Growth and Scalability:** The referral system can significantly contribute to the platform's growth by leveraging the networks of its users. A successful referral program can be a cost-effective marketing strategy, reducing reliance on traditional advertising while simultaneously expanding the user base.

### Mechanisms of Distribution

- **Piggy Bank Contract:** The term "piggy bank" suggests that rewards accumulated through the Hikuru Fees Claimer are stored in a specific contract, likely a smart contract in the context of blockchain or decentralized platforms. Users can claim their accumulated rewards from this contract, providing a transparent and secure method of distribution.

- **Transparency and Trust:** Implementing the Fees Claimer as a contract ensures transparency in how rewards are calculated and distributed. Users can verify their referrals' contributions and understand how their rewards are generated, building trust in the platform.

### Considerations

- **Sustainability of the Revenue Sharing Model:** The platform must maintain a delicate balance between rewarding its users and ensuring its own financial sustainability. The percentage of profits shared and the scope of services included must be managed carefully to ensure long-term viability.

- **Security and Fraud Prevention:** With financial incentives at play, the platform must implement robust security measures and fraud detection mechanisms to prevent abuse of the referral system.



## Overview Contract

The `FeeClaimer` contract is designed to manage fees, yield, and gas claims within a decentralized finance (DeFi) ecosystem. It leverages the `IBlast` interface to interact with external contracts for claiming yields and gas efficiently. The contract incorporates features such as fee deposit, fee claim, yield claim, and gas claim functionalities, alongside security measures like reentrancy guards to ensure safe and atomic operations.


![image](https://github.com/HikuruOfficial/Hikuru-Fees-Claimer/assets/132744928/edd90011-78ae-47b8-9ab7-13d0e623d6d0)

## Features Contract

- **Fee Management**: Allows users to deposit fees and claim them back.
- **Yield and Gas Claim**: Integrates with the `IBlast` interface to claim yield and gas, offering flexibility in handling contract yields and operational costs.
- **Security**: Utilizes `ReentrancyGuard` from OpenZeppelin to prevent reentrancy attacks.
- **Ownership Control**: Includes ownership functionality to restrict certain actions to the contract owner.
- **Event Logging**: Emits events for deposits and claims, facilitating transparency and traceability.

## Setup Contract

### Prerequisites

- Node.js and npm installed.
- Truffle or Hardhat for compilation and deployment.
- An Ethereum wallet with ETH for deployment and interaction.

### Installation

1. Clone the repository and navigate into it:


```shell
git clone https://github.com/HikuruOfficial/Hikuru-Fees-Claimer.git
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
