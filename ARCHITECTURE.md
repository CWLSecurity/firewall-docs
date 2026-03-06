# Firewall Vault — Architecture

## High-level idea
Firewall Vault is a non-custodial transaction firewall for EVM wallets.

It protects users by enforcing transaction rules on-chain before execution.

## High-level flow

    User
      ↓
    FirewallModule
      ↓
    PolicyRouter
      ↓
    Policies
      ↓
    ALLOW / DELAY / REVERT

## What each layer does

### User
The user initiates an action from the UI through a connected wallet.

### FirewallModule
The FirewallModule is the smart-account style execution layer.
It receives the intended transaction and forwards it into the policy system.

### PolicyRouter
The PolicyRouter evaluates the transaction against active policy logic.

### Policies
Policies determine whether the transaction should:
- proceed immediately
- be delayed
- be reverted

## Core contracts
- `FirewallModule`
- `PolicyRouter`
- `FirewallFactory`

## Main policies
- `InfiniteApprovalPolicy`
- `LargeTransferDelayPolicy`
- `NewReceiverDelayPolicy`
- `UnknownContractBlockPolicy`

## Presets
- `0` — Conservative
- `1` — DeFi Trader

## Execution outcomes

### Allow
The transaction is executed immediately.

### Delay
The transaction is placed into the on-chain delayed queue and can be executed later when unlocked.

### Revert
The transaction is blocked and does not execute.

## Delayed queue
Firewall Vault supports:
- `schedule`
- `executeScheduled`
- `cancelScheduled`

The delay logic is enforced on-chain.

## MVP scope
Current MVP focuses on:
- Base Mainnet
- core policy enforcement
- create/import wallet flow
- ETH send flow
- delayed queue management
- read-only dashboard mode

## What is intentionally out of scope in MVP
- ERC20 UI
- calldata decoding UI
- policy editor UI
- backend analytics
- mobile app
