# Firewall Vault — Security Model (MVP)

## Purpose
Firewall Vault is a non-custodial transaction firewall for EVM wallets.

Its purpose is not to warn about risk after the fact, but to enforce transaction rules on-chain before execution.

## Core guarantees
Firewall Vault is designed around the following guarantees:

- Non-custodial
- On-chain enforcement
- Policy decision flow: allow / delay / revert
- Decision priority: revert > delay > allow
- Delay queue enforced on-chain
- No backend policy engine
- No off-chain trust required for transaction enforcement

## Base security invariants (V2)
- Each wallet is created with a fixed base pack.
- Base pack cannot be removed after wallet creation.
- Base protections remain mandatory and always active for that wallet.
- Premium/add-on packs cannot replace or weaken base protections.
- Add-ons may only add extra checks.
- Entitlement is checked when enabling add-ons (not per-transaction).
- Enabled add-on policies are snapshotted in wallet router storage.
- Registry deactivation does not disable already-enabled add-on protection.

Current mandatory base protections:
- `InfiniteApprovalPolicy`
- `LargeTransferDelayPolicy`
- `NewReceiverDelayPolicy`

## UI behavior
The UI is designed with the following properties:

- UI never stores private keys
- Transaction signing happens through MetaMask or another injected wallet
- UI is stateless except for localStorage persistence of wallet-related convenience data
- Read-only mode does not grant transaction authority

## What Firewall Vault is intended to protect against
Firewall Vault is intended to reduce the risk of transaction patterns such as:

- infinite token approvals
- transfers to new or unknown recipients
- calls to unknown contracts
- large transfers that should not execute instantly

In V2, additional curated add-on packs can strengthen this posture when entitled.

## What Firewall Vault does not guarantee
Firewall Vault does not guarantee protection against every possible loss scenario.

In MVP form, it does not guarantee protection against:

- compromise of the user's EOA or browser wallet
- malware on the user's device
- phishing that tricks the user into approving an unsafe wallet setup outside the intended flow
- RPC manipulation affecting reads or UI perception
- vulnerabilities in third-party wallets, browser extensions, or user environment
- unknown smart contract bugs if unaudited

## Assumptions
The MVP assumes:

- the user controls the EOA used with the system
- the user's signing wallet is not already compromised
- the connected RPC is trustworthy enough for read operations
- deployed contracts correspond to the intended verified source code
- the user verifies they are interacting with the real Firewall Vault deployment
- policy packs in `PolicyPackRegistry` are curated and reviewed before activation
- entitlement manager logic correctly reports `isEntitled(owner, packId)` for paid/add-on access

## Trust boundaries
Firewall Vault minimizes trust in off-chain systems for enforcement, but trust still exists in:

- the user's local environment
- the browser wallet
- the frontend delivery path
- the RPC provider for reads
- the correctness of deployed smart contracts
- registry and entitlement governance/operations for curated pack lifecycle

## Key limitations
- MVP stage
- contracts may be unaudited
- UI supply chain risk exists
- browser wallet compromise defeats UI-layer trust
- queue lookback limitations may affect discovery in the UI
- delays may temporarily block urgent user actions

## Summary
Firewall Vault reduces risk by moving transaction enforcement into smart contracts.

It improves security posture by replacing part of the traditional warning-based model with on-chain decision enforcement, but it is not a complete substitute for wallet hygiene, device security, and careful user verification.
