# Firewall Vault

**Protected version of your wallet**

Firewall Vault is a non-custodial transaction firewall for EVM wallets.

Unlike traditional wallet security tools, it does not only simulate or warn.  
It enforces transaction rules **on-chain** before execution.

## What makes Firewall Vault different
Most wallet-security products focus on:
- simulation
- risk warnings
- off-chain analysis

Firewall Vault takes a different approach:
- safe actions can proceed
- sensitive actions can be delayed
- dangerous actions can be reverted

## Core principles
- Non-custodial
- On-chain enforcement
- No backend
- No off-chain policy engine
- No AI-based trust assumptions
- Security logic enforced by smart contracts

## MVP status
Current MVP status:
- Core contracts deployed on Base
- UI MVP implemented
- Read-only mode implemented
- Delayed transaction queue implemented
- GitHub repositories published

## Repositories
- `firewall-wallet` — smart contracts and core enforcement logic
- `firewall-ui` — frontend for using Firewall Vault
- `PROJECT_HOME` — launch, trust, and security documentation

## Key documentation
- `SECURITY_MODEL.md`
- `LAUNCH_CHECKLIST.md`
- `INFO_CAMPAIGN_PLAN.md`

## Who this is for
- Security-focused DeFi users
- Power users
- Early adopters
- Users who want transaction enforcement instead of only warnings

## Important note
This is an MVP.  
If the contracts are not audited, the product must be treated as unaudited software.

## Core message
**On-chain enforcement, not warnings.**  
**No custody, no backend.**
