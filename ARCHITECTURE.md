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
    PolicyPackRegistry + Entitlement Hook
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
The PolicyRouter evaluates the transaction against:
- fixed base pack policies (selected at wallet creation),
- enabled add-on policy snapshots stored in the wallet router.

Final decision priority:
- `REVERT` > `DELAY` > `ALLOW`

### Policies
Policies determine whether the transaction should:
- proceed immediately
- be delayed
- be reverted

## Core contracts
- `FirewallModule`
- `PolicyRouter`
- `FirewallFactory`
- `PolicyPackRegistry`
- `IEntitlementManager` hook (minimal implementation: `SimpleEntitlementManager`)

## Main policies
- `InfiniteApprovalPolicy`
- `LargeTransferDelayPolicy`
- `NewReceiverDelayPolicy`
- `UnknownContractBlockPolicy`

## Pack model (V2)
### Base packs (fixed)
- selected during `createWallet(owner, recovery, basePackId)`
- immutable per wallet after creation
- mandatory security layer

### Add-on packs (curated)
- optional extra policy packs
- enabled by wallet owner only if entitlement permits
- can only add checks on top of base security
- policy addresses are snapshotted into each wallet router at enable time
- registry deactivation blocks new enablements only (does not remove already-enabled protection)

### Effective policy set
`Base Pack + Enabled Add-on Snapshots`

Current base IDs:
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
- fixed base pack security
- add-on entitlement hook foundation
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
