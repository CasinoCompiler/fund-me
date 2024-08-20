# FundMe Smart Contract

## Overview

FundMe is a Solidity smart contract that allows users to fund the contract with ETH. It uses Chainlink Price Feeds to ensure that the funded amount meets a minimum USD value. The contract owner can withdraw the funds.

## Features

- Accept ETH funding from users
- Enforce a minimum funding amount in USD
- Keep track of funders and their contributions
- Allow the contract owner to withdraw funds
- Use Chainlink Price Feeds for ETH/USD conversion

## Contract Details

- Solidity Version: 0.8.19
- License: MIT

## Dependencies

- Chainlink Contracts (for AggregatorV3Interface)
- PriceConverter Library (custom library for price conversion)

## Key Functions

1. `fundWithEth()`: Allows users to fund the contract with ETH.
2. `withdraw()`: Allows the owner to withdraw all funds from the contract.
3. `cheaperWithdraw()`: A gas-optimized version of the withdraw function.
4. Various getter functions to retrieve contract state.

## Usage

### Deployment

1. Deploy the contract with the address of the Chainlink Price Feed for ETH/USD.
2. The deploying address becomes the owner of the contract.

### Funding

Users can fund the contract by calling `fundWithEth()` and sending ETH. The function ensures that the ETH amount is equivalent to at least 5 USD.

### Withdrawing

The contract owner can withdraw all funds using either `withdraw()` or `cheaperWithdraw()`.

## Security Features

- `onlyOwner` modifier to restrict access to critical functions.
- Use of `immutable` and `private` variables for gas optimization and security.
- Custom error for unauthorized access attempts.

## Notes

- The contract includes both `receive()` and `fallback()` functions to handle direct ETH transfers.
- The minimum funding amount is set to 5 USD (represented as 5 * 1e18 to account for decimals).

## Development and Testing

To work with this contract:

1. Set up a Solidity development environment (e.g., Hardhat, Truffle).
2. Deploy to a testnet using the appropriate Chainlink Price Feed address.
3. Interact with the contract using a web3 library or through a blockchain explorer.

Remember to thoroughly test the contract before deploying to mainnet.