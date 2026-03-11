# Firewall Vault — Deployment (V2)

## Core deployment model
Firewall Vault V2 core deploys:
- policy contracts,
- `PolicyPackRegistry` with curated base/add-on packs,
- entitlement manager (`isEntitled(owner, packId)` hook),
- `FirewallFactory` bound to registry + entitlement.

## Base packs
- Base pack `0`: Conservative
- Base pack `1`: DeFi Trader

Both remain fixed per wallet after creation and preserve existing base policy behavior/parameters.

## Wallet creation
`createWallet(owner, recovery, basePackId)` creates:
- `FirewallModule`
- per-wallet `PolicyRouter` bound to selected base pack.

## Add-on packs
Add-ons are curated packs in registry and can be enabled only if entitlement allows.
They only add checks to base security.
When enabled, add-on policy addresses are snapshotted into the wallet router.
If registry later deactivates a pack, only future enablements are blocked.
Already-enabled wallets keep their add-on protections active.

## Effective policy set
`Base Pack + Enabled Add-on Snapshots`  
Decision priority remains `REVERT > DELAY > ALLOW`.

## Contract-level deployment details
See:
- [`../firewall-wallet/DEPLOYMENT.md`](../firewall-wallet/DEPLOYMENT.md)
