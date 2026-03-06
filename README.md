# Firewall Vault Documentation

**Protected version of your wallet**

Firewall Vault is an on-chain transaction firewall for EVM wallets.

It does not only simulate transactions or show warnings.  
It enforces transaction rules **on-chain** before execution.

## What Firewall Vault is
Firewall Vault is a non-custodial wallet protection model built around smart-account style transaction enforcement.

Instead of asking the user to interpret warnings, Firewall Vault applies rules that can:

- allow safe actions
- delay sensitive actions
- revert dangerous actions

## Why it matters
Most wallet-security tools focus on:
- simulation
- warnings
- off-chain analysis

Firewall Vault takes a different approach:
- no backend trust for policy decisions
- no off-chain risk engine
- no AI-based scoring
- direct on-chain enforcement

## Core message
**On-chain enforcement, not warnings.**  
**No custody, no backend.**

## Current MVP status
- Core contracts deployed on Base
- UI MVP implemented
- Read-only mode implemented
- Delayed queue implemented
- Repositories published on GitHub

## Repositories
- [`../firewall-wallet`](../firewall-wallet) — smart contracts and enforcement layer
- [`../firewall-ui`](../firewall-ui) — frontend for using Firewall Vault
- `PROJECT_HOME` — documentation, launch materials, and trust materials

## Where to start
If you are new to the project, read in this order:

1. [`README.md`](./README.md)
2. [`ARCHITECTURE.md`](./ARCHITECTURE.md)
3. [`SECURITY_MODEL.md`](./SECURITY_MODEL.md)
4. [`LAUNCH_CHECKLIST.md`](./LAUNCH_CHECKLIST.md)

## Documentation map
- [`ARCHITECTURE.md`](./ARCHITECTURE.md) — high-level product and contract flow
- [`SECURITY_MODEL.md`](./SECURITY_MODEL.md) — MVP security assumptions and limitations
- [`LAUNCH_CHECKLIST.md`](./LAUNCH_CHECKLIST.md) — operational launch checklist
- [`INFO_CAMPAIGN_PLAN.md`](./INFO_CAMPAIGN_PLAN.md) — launch messaging and outreach plan

## Who this is for
- Security-focused DeFi users
- Power users
- Early adopters
- Users who want enforcement instead of only warnings

## MVP limitations
- MVP stage
- Base-first deployment
- No ERC20 UI
- No policy editor UI
- No backend analytics
- Audit status must be checked separately

## Important note
If the contracts are not audited, Firewall Vault must be treated as unaudited software.

## Positioning
Firewall Vault is not just another wallet warning layer.

It aims to be a **wallet-level transaction firewall** for EVM users.
