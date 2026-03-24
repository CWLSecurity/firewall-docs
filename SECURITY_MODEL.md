# Firewall Vault — Security Model (Current v1 / v1.5)

## 1. Security objective
Reduce wallet-drain impact by enforcing deterministic on-chain controls before execution.

## 2. Enforcement model
Every action is evaluated through `PolicyRouter`.
Final outcome is deterministic:
- `REVERT` > `DELAY` > `ALLOW`

No off-chain risk engine is required for enforcement.

## 3. Pack security model
- Each wallet has one fixed base pack.
- Optional add-on packs can be enabled later if entitled.
- Add-ons are additive only.
- Enabled add-ons persist once enabled in current router behavior.

Current curated packs:
- Base `0`: Conservative
- Base `1`: DeFi Trader
- Add-on `2`: Approval Hardening
- Add-on `3`: New Receiver 24h Delay
- Add-on `4`: Large Transfer 24h Delay

## 4. Implemented hardening (phases)
### Phase 1
- Scheduled execution hardening:
  - `executeScheduled` re-evaluates current policy state.
  - If current decision is `Revert`, execution is blocked.
- Strict approval hardening:
  - `approve(0)` allowed,
  - `approve(non-zero)` blocked,
  - `increaseAllowance(0)` allowed,
  - `increaseAllowance(non-zero)` blocked,
  - `setApprovalForAll(true)` blocked,
  - permit-like selectors blocked in strict packs unless explicitly allowed.

### Phase 2
DeFi compensating controls:
- `ApprovalToNewSpenderDelayPolicy`
  - non-zero approval to EOA spender => `Revert`
  - first non-zero approval to new contract spender => `Delay`
- `Erc20FirstNewRecipientDelayPolicy`
  - first ERC20 `transfer`/`transferFrom` recipient => `Delay`

Post-exec state updates are protected by trusted caller checks in `onExecuted` paths.

### Phase 3A
`LargeTransferDelayPolicy` hardening:
- delay on `>=` threshold,
- separate ETH/ERC20 threshold configuration,
- scope kept explicit and narrow.

### Phase 3B
- `FirewallFactory.createWallet(owner, ...)` requires `msg.sender == owner`.
- `NewEOAReceiverDelayPolicy` delays first unknown-selector call to a new contract target.
- `NewEOAReceiverDelayPolicy` and `NewReceiverDelayPolicy` parse NFT transfer selectors for recipient extraction.
- `FirewallModule` supports inbound safe NFT transfers via `ERC721` / `ERC1155` receiver hooks.

## 5. Current guarantees
- Deterministic policy folding per action.
- Queue actions remain policy-governed.
- Strict approval protections remain available in strict packs.
- DeFi pack remains usable while adding targeted approval/outflow friction.
- DeFi line now adds one-time delay friction for unknown-selector calls to new contract targets.
- Large transfer delays remain active in all curated packs.
- Add-ons can increase strictness but cannot weaken base policies.

## 6. Known limitations and tradeoffs
- Add-on disable path is not present in current router.
- Registry deactivation/entitlement revocation does not remove already-enabled add-ons.
- ERC20 thresholds are raw-unit based, not economically normalized.
- Large-transfer policy does not cover arbitrary calldata economic semantics.
- Delay adds review window but is not absolute prevention if owner later executes malicious intent.
- Endpoint and device security (wallet extension, browser, machine compromise) remain out of protocol control.

## 7. Trust boundaries
Users still trust:
- signer wallet integrity,
- frontend delivery integrity,
- RPC correctness for reads,
- deployed contract correctness,
- governance/operations around registry/entitlements.

## 8. Product security posture
Firewall Vault is a protected execution layer, not a full standalone wallet replacement.

Current UX model:
- Firewall UI as security console,
- signer wallet for keys/signatures,
- future Vault Connector as compatibility bridge.
