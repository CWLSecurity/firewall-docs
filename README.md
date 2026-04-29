# Firewall Vault Documentation Hub

Last updated: 2026-04-29

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
  - Base `0`: Vault
  - Base `1`: DeFi Trader
- Additive protection packs currently surfaced:
  - Add-on `2`: 24-Hour New Receiver Delay
  - Add-on `3`: 24-Hour Large Transfer Delay
- Current Base `0` (`Vault`) production line has two active base policies:
  - `LargeTransferDelayPolicy`
  - `NewReceiverDelayPolicy`
- `InfiniteApprovalPolicy` exists in the contract codebase and deployment manifest, but it is not part of the current live Base `0` pack. There is no active Approval Hardening add-on pack in the current live line.
- Delayed queue lifecycle in UI (review / execute / cancel).
- Per-Vault queue bot automation with owner-controlled executor role.
- Vault creation supports initial bot gas buffer funding.
- Policy introspection-driven display with business-language mapping.

## MVP Scope (In / Out)
In MVP now:
- `firewall-wallet`: Base deployment line with curated packs and queue semantics.
- `firewall-ui`: primary user path (connect, create/import vault, send/receive, queue actions).
- `PROJECT_HOME`: canonical product/security/deployment documentation.

Out of MVP (next stage):
- `firewall-connector` browser-extension rollout.
- partner dApp wrapper integrations through connector.
- multi-chain expansion beyond Base Mainnet.

## MVP Usage Path (Current)
1. User connects signer wallet in `firewall-ui`.
2. User creates/imports Vault.
3. User sends/receives through Vault from `Actions`.
4. Delayed actions are managed in `Queue`.
5. Optional: enable Vault queue bot in Queue modal for auto-execution after unlock.
6. Keep bot gas buffer funded for expected delayed-transaction volume.

Post-MVP:
- `firewall-connector` (extension/partner dApp embedding) is rollout phase after MVP sign-off.

## Repository Map
- `../firewall-wallet`
  - canonical smart contracts and policy semantics
- `../firewall-ui`
  - active user-facing security console
- `../firewall-connector`
  - EIP-1193 vault-visible connector boundary

## Docs In This Folder
- `README.md`
- `SECURITY.md`
- `TERMS_OF_USE.md`
- `PRIVACY_NOTICE.md`

## Messaging Guardrails (Short)
Safe claims:
- "On-chain transaction firewall for Base."
- "Non-custodial protection; signer wallet keeps keys."
- "Deterministic allow/delay/block policy enforcement."

Avoid claims:
- "Guaranteed protection from all losses."
- "Universal dApp compatibility out of the box."
- "AI-driven transaction safety engine."
