# Firewall Vault Documentation Hub

Last updated: 2026-03-24

This folder is the cross-repo documentation hub for Firewall Vault.

## Current Product Snapshot
Firewall Vault is a non-custodial on-chain transaction firewall on Base.

Core runtime model:
- Signer wallet keeps private keys.
- Vault (`FirewallModule`) executes protected actions.
- `PolicyRouter` enforces deterministic policy outcomes (`REVERT > DELAY > ALLOW`).
- `firewall-ui` is the active security console.
- `firewall-connector` is the EIP-1193 integration boundary package.

## What Is Live Now
- Vault creation/import flows in UI.
- Two base protection lines:
  - Base `0`: Vault Safe
  - Base `1`: DeFi Trader
- Additive protection packs currently surfaced:
  - Add-on `2`: Approval Hardening
  - Add-on `3`: 24-Hour New Receiver Delay
  - Add-on `4`: 24-Hour Large Transfer Delay
- Delayed queue lifecycle in UI (review / execute / cancel).
- Policy introspection-driven display with business-language mapping.

## Repository Map
- `../firewall-wallet`
  - canonical smart contracts and policy semantics
- `../firewall-ui`
  - active user-facing security console
- `../firewall-connector`
  - EIP-1193 vault-visible connector boundary

## Core Docs In This Folder
- `ARCHITECTURE.md`
- `DEPLOYMENT.md`
- `SECURITY.md`
- `SECURITY_MODEL.md`
- `VERIFY_YOUR_FIREWALL.md`
- `LAUNCH_CHECKLIST.md`
- `SMOKE_TEST_PLAN.md`
- `Risk.md`
- `next_step.md`
- `MARKETING_BRIEF.md`

## CI / Smoke / Integrity
- `PROJECT_HOME`: docs integrity check via `./scripts/integrity.sh check`
- `firewall-ui`: `npm run smoke` + `npm run integrity:check`
- `firewall-wallet`: `npm run test:contracts`, `npm run smoke:contracts`, `npm run integrity:check`

## Messaging Guardrails (Short)
Safe claims:
- "On-chain transaction firewall for Base."
- "Non-custodial protection; signer wallet keeps keys."
- "Deterministic allow/delay/block policy enforcement."

Avoid claims:
- "Guaranteed protection from all losses."
- "Universal dApp compatibility out of the box."
- "AI-driven transaction safety engine."
