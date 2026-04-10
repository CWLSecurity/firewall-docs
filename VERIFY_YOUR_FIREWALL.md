# Verify Your Firewall (Current v2)

Last updated: 2026-03-25

This guide explains how to verify that your deployed/used Firewall Vault setup matches the intended architecture.

## 1. Verify core contract wiring
Confirm addresses for:
- `FirewallFactory`
- `PolicyPackRegistry`
- `SimpleEntitlementManager` (or compatible entitlement hook)
- your wallet `FirewallModule`
- your wallet `PolicyRouter`

Verify router is bound to your wallet and base pack id.
Factory auth expectation:
- `createWallet(owner, ...)` requires caller is the same `owner`.
- Newly created vault should expose `feeConfigAdmin() == owner`.
- if vault was created with initial bot funding, `botGasBuffer()` should reflect that funded amount.
- Owner discovery expectation:
  - `latestWalletOfOwner(owner)` should return the newest factory vault for that owner.

## 2. Verify pack registrations
In `PolicyPackRegistry`, confirm curated lineup:
- Base `0` Conservative
- Base `1` DeFi Trader
- Add-on `2` Approval Hardening
- Add-on `3` New Receiver 24h Delay
- Add-on `4` Large Transfer 24h Delay

For each pack verify:
- active status,
- pack type (`BASE` / `ADDON`),
- policy list.

## 3. Verify active policy composition per wallet
For your wallet router verify:
- base policy snapshot (`policies(i)`),
- enabled add-on packs and their snapshotted policies.

Remember:
- add-on snapshots stay active once enabled,
- later registry deactivation/entitlement changes do not remove already-enabled snapshots.

## 4. Verify policy identity and config
For each active policy address read:
- `policyKey()`
- `policyName()`

Then read policy-specific config getters.

Large transfer policy must expose:
- `ETH_THRESHOLD_WEI`
- `ERC20_THRESHOLD_UNITS`
- `DELAY_SECONDS`

## 5. Verify critical behavior assumptions
- Router decision order is `REVERT > DELAY > ALLOW`.
- Scheduled execution path (`executeScheduled`) is still policy-rechecked and blocked if current decision is `Revert`.
- Strict packs keep non-zero approval hard blocks.
- DeFi pack includes compensating controls for first risky spender/recipient patterns.
- DeFi line delays first unknown-selector call:
  - to first-time EOAs,
  - and per first-time `(contract target, selector)` for contracts.

## 6. Verify NFT receive compatibility
For wallet module address verify:
- `supportsInterface(0x01ffc9a7) == true` (`IERC165`)
- `supportsInterface(0x150b7a02) == true` (`IERC721Receiver`)
- `supportsInterface(0x4e2312e0) == true` (`IERC1155Receiver`)

## 6A. Verify queue bot path (if enabled)
- Verify relayer authorization:
  - `isQueueExecutor(relayer) == true` for your Vault.
- Verify reserve prerequisites for automation:
  - queued tx intended for bot execution should have non-zero `scheduledReserve(txId)`.
- Verify UI/server status in Queue modal:
  - `Server bot: Enabled`
  - `Executor on-chain: Enabled`
- Verify revocation:
  - after disable action, `isQueueExecutor(relayer) == false`.

## 7. Verify frontend integrity
Confirm you are using intended repositories and deployment:
- `firewall-wallet`
- `firewall-ui`
- `PROJECT_HOME`

## 8. Know current limits before trusting meaningful funds
- MVP / audit status applies unless explicitly updated.
- ERC20 large-transfer thresholding is raw-unit based.
- Large-transfer policy scope is limited to ETH value + ERC20 `transfer`/`transferFrom`.
- UI remains the primary security console in current product stage.

For contract-level commands and exact read paths, use:
- `firewall-wallet/VERIFY_DEPLOYMENT.md`
