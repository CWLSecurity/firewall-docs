# Firewall Vault — Security Model (Current v2)

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
- Add-on `2`: New Receiver 24h Delay
- Add-on `3`: Large Transfer 24h Delay

## 4. Implemented hardening (phases)
### Phase 1
- Scheduled execution hardening:
  - `executeScheduled` re-evaluates current policy state.
  - If current decision is `Revert`, execution is blocked.
- Approval hardening primitive:
  - `InfiniteApprovalPolicy` exists in the codebase and can enforce strict non-zero approval blocking when included in a pack.
  - Current live Base `0` pack does not include `InfiniteApprovalPolicy`.
  - Current live curated add-ons do not include an Approval Hardening pack.

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
- New vaults default `feeConfigAdmin` to wallet owner.
- `FirewallFactory` exposes deterministic owner->vault discovery (`latestWalletOfOwner`).
- `NewEOAReceiverDelayPolicy` delays first unknown-selector call to a new EOA target.
- `NewEOAReceiverDelayPolicy` delays first unknown-selector call per `(contract target, selector)`.
- `NewEOAReceiverDelayPolicy` and `NewReceiverDelayPolicy` parse NFT transfer selectors for recipient extraction.
- `FirewallModule` supports inbound safe NFT transfers via `ERC721` / `ERC1155` receiver hooks.

### Phase 4 (queue automation)
- Owner can authorize/revoke bot relayer on-chain:
  - `setQueueExecutor(relayer, true|false)`.
- Bot executes only via:
  - `executeScheduledByExecutor(txId)`.
- Bot runtime uses relayer key only (owner key is not required or stored).
- Early execution is still blocked by unlock checks and policy re-validation.
- Queue reserve model:
  - `schedule(...)` auto-reserves from Vault bot gas pool,
  - pool can be seeded at Vault creation (payable `createWallet`) and topped up later,
  - relayer refund is capped by on-chain gas caps.

## 5. Current guarantees
- Deterministic policy folding per action.
- Queue actions remain policy-governed.
- Strict approval protections are available as a code-level policy primitive, but they are not active in the current live Base `0` pack or add-on catalog.
- DeFi pack remains usable while adding targeted approval/outflow friction.
- DeFi line now adds one-time delay friction for unknown-selector first calls:
  - to EOAs,
  - and per `(contract target, selector)` for contracts.
- Large transfer delays remain active in all curated packs.
- Add-ons can increase strictness but cannot weaken base policies.
- Queue bot cannot bypass unlock windows.
- Queue bot authorization is owner-controlled per Vault.

## 6. Known limitations and tradeoffs
- Add-on disable path is not present in current router.
- Registry deactivation/entitlement revocation does not remove already-enabled add-ons.
- ERC20 thresholds are normalized to 1e18 units via token `decimals()` (still not economically price-normalized).
- Tokens with non-standard/missing `decimals()` metadata fall back to 18-decimal interpretation.
- Large-transfer policy does not cover arbitrary calldata economic semantics.
- Delay adds review window but is not absolute prevention if owner later executes malicious intent.
- Endpoint and device security (wallet extension, browser, machine compromise) remain out of protocol control.
- Queue bot is an external service and must stay online to execute automatically.
- If bot is offline, owner can still execute manually from queue UI.

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
- post-MVP Vault Connector as compatibility bridge.
- connector hardened defaults avoid exposing upstream provider in page globals.
