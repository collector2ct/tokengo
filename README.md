# Token Vesting Smart Contract

## Description

This smart contract implements a token vesting system. It allows the owner to lock up tokens for a specific address, and the tokens are gradually released over a defined period. This can be used in scenarios like employee incentive programs or project milestones where tokens are locked for a specific period.

## Contract Functions

- **addVestingSchedule**: The contract owner can add a new vesting schedule for a beneficiary, defining the amount of tokens, and the release time.
- **releaseTokens**: Beneficiaries can release their vested tokens after the release time has passed.
- **withdraw**: The contract owner can withdraw any excess tokens from the contract.

## Setup

1. Install [Node.js](https://nodejs.org/en/) if it's not already installed.
2. Install [Truffle](https://www.trufflesuite.com/truffle) for smart contract development.

```bash
npm install -g truffle
