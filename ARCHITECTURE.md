# Firewall Vault — Architecture (Current)

Last updated: 2026-03-23

## 1. System Overview

    Signer Wallet (MetaMask/Rabby)
      ↓ owner-signed calls
    Firewall UI (security console)
      ↓
    FirewallModule (Vault executor)
      ↓ evaluate
    PolicyRouter
      ↓
    Base Pack + Enabled Add-on Policies
      ↓
    REVERT / DELAY / ALLOW

## 2. Core Principles
- Deterministic on-chain enforcement.
- Non-custodial key ownership (signer wallet keeps keys).
- Pack-based composition (one base pack + additive add-ons).
- Router outcome priority is fixed (`REVERT > DELAY > ALLOW`).
- No off-chain policy engine.

## 3. Core Contract Set
- `FirewallModule`
- `PolicyRouter`
- `FirewallFactory`
- `PolicyPackRegistry`
- `SimpleEntitlementManager`
- `ProtocolRegistry`
- `TrustedVaultRegistry`

## 4. Decision Model
Router folding:
- any policy returns `Revert` -> final `Revert`
- else any policy returns `Delay` -> final `Delay` (max delay)
- else -> `Allow`

This model is deterministic and policy-order independent for strictness outcome.

## 5. Pack Model
Base packs (fixed at create time):
- Base `0`: Conservative (`Vault Safe` in UI)
- Base `1`: DeFi Trader

Add-on packs (enabled later, additive):
- Add-on `2`: Approval Hardening
- Add-on `3`: New Receiver 24h Delay
- Add-on `4`: Large Transfer 24h Delay

Current semantics:
- Enabled add-ons are snapshotted in router state.
- Add-ons are additive only.
- Current router line has no disable path for enabled add-ons.

## 6. Product Surface Split
- `firewall-wallet`: canonical contract semantics.
- `firewall-ui`: active user-facing security console.
- `firewall-connector`: EIP-1193 connector boundary (MVP maturity; integration boundary, not universal wallet replacement).

## 7. Security-Relevant Runtime Notes
- Scheduled execution is re-checked against current policy state.
- Large-transfer policy uses explicit ETH/ERC20 thresholds with `>=` trigger semantics.
- Policy metadata introspection (`policyKey`, `policyName`, `policyDescription`, `policyConfigVersion`, `policyConfig`) is required for admissible policies.

## 8. Known Product Constraints (Current)
- Base chain scope: Base Mainnet.
- Add-on permanence semantics in current router model.
- Large-transfer selector scope is intentionally narrow (`ETH value`, ERC20 `transfer` / `transferFrom`).

## 9. Canonical Detail Sources
- `../firewall-wallet/PACK_MATRIX.md`
- `../firewall-wallet/SECURITY_MODEL.md`
- `../firewall-wallet/VERIFY_DEPLOYMENT.md`
- `../firewall-ui/UI_ARCHITECTURE.md`
