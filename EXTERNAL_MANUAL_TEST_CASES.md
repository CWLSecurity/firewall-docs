# Firewall Vault — External Manual Test Cases (Full Functional Pass)

Last updated: 2026-04-24

## 1) Purpose
This checklist is for an external tester to validate the end-to-end MVP user journey in production.

Goal:
- verify all core user-visible functionality,
- verify key negative/error paths,
- verify launch-critical security behavior at UI level.

This is a manual functional suite (not a smart-contract audit).

## 2) Scope
In scope:
- public site availability and basic runtime health
- wallet connect and network gating
- vault create/import lifecycle
- send/receive flows
- queue lifecycle (delay -> execute/cancel)
- protection visibility and add-on enabling
- queue bot enable/disable UX path
- disconnect behavior

Out of scope:
- deep browser compatibility matrix
- load/performance benchmarking
- exhaustive protocol fuzzing

## 3) Test Environment
- Site: `https://firewall-wallet.com`
- Bot API health: `https://bot.firewall-wallet.com/api/v1/bot/health`
- Network: Base Mainnet (`8453`)
- Wallet: MetaMask or Rabby
- Browser: latest Chrome (desktop), plus one mobile check (MetaMask in-app browser)
- Test funds:
  - signer EOA: Base ETH for gas + direct-send checks
  - vault: small ETH + small ERC20 for send/queue checks

## 4) Result Format
For each case capture:
- case id
- status: `PASS` / `FAIL`
- evidence: screenshot or tx hash
- notes

Global result:
- `PASS`: no blocker/critical failures
- `PASS WITH ISSUES`: only major/minor issues
- `FAIL`: any blocker/critical failure

## 5) Severity
- Blocker: launch should stop
- Critical: core security/control flow broken
- Major: important UX flow degraded
- Minor: cosmetic/non-blocking inconsistency

## 6) Manual Test Cases

### A. Availability and Session

#### TC-A1 Site availability
Steps:
1. Open `https://firewall-wallet.com`.
2. Open `https://www.firewall-wallet.com`.

Expected:
- both domains load without browser security warnings,
- app shell renders and is usable.

Severity on fail: Blocker

#### TC-A2 Bot runtime health (read-only)
Steps:
1. Open `https://bot.firewall-wallet.com/api/v1/bot/health`.

Expected:
- JSON response with `ok: true`,
- `runtime.hasBaseRpc: true`,
- `runtime.hasRelayerKey: true`,
- `security.mutationAuthMode` is not `unsafe-remote`.

Severity: Critical

#### TC-A3 Wallet connect (Base)
Steps:
1. Connect wallet on Base network.

Expected:
- connected signer address is shown,
- no broken state after connect.

Severity: Blocker

#### TC-A4 Wrong-network gate
Steps:
1. Switch wallet network away from Base.
2. Return to app.

Expected:
- clear wrong-network warning,
- critical actions are blocked until network is switched back.

Severity: Blocker

### B. Vault Lifecycle

#### TC-B1 Create Vault (Vault Safe)
Steps:
1. Start from account with no discovered vault.
2. Choose base profile `Vault Safe`.
3. Submit create transaction.

Expected:
- wallet prompt appears,
- pending state is clear,
- after confirmation and discovery, vault dashboard appears.

Severity: Blocker

#### TC-B2 Create Vault rejection handling
Steps:
1. Start create flow.
2. Reject transaction in wallet.

Expected:
- clear error shown,
- no frozen pending state,
- user can retry.

Severity: Critical

#### TC-B3 Create Vault with initial bot gas buffer
Steps:
1. In create flow, set non-zero initial bot gas buffer.
2. Complete creation.

Expected:
- create succeeds,
- vault is created,
- bot gas buffer is reflected in UI/read paths where shown.

Severity: Critical

#### TC-B4 Import existing Vault
Steps:
1. Use wallet with already-deployed owner-bound vault.
2. Use `Import Existing Vault`.

Expected:
- correct vault is found and selected,
- no duplicate/incorrect vault association.

Severity: Critical

#### TC-B5 Disconnect Vault (not wallet)
Steps:
1. With active vault selected, click `Disconnect Vault`.
2. Refresh app.

Expected:
- vault stays disconnected,
- app does not auto-reconnect vault in background,
- reconnect only via explicit user action (create/import).

Severity: Critical

#### TC-B6 Full wallet disconnect
Steps:
1. Trigger full wallet disconnect.

Expected:
- app returns to disconnected state,
- no stale vault-privileged controls remain visible.

Severity: Major

### C. Protection and Policy Surfaces

#### TC-C1 Base protections visibility
Steps:
1. Open dashboard with active vault.

Expected:
- active base protections are visible,
- labels/tooltips are understandable for non-technical users.

Severity: Major

#### TC-C2 Add-on catalog visibility
Steps:
1. Open `Manage Protection`.

Expected:
- add-on packs are listed,
- state (available/locked/enabled) is readable.

Severity: Major

#### TC-C3 Enable add-on pack
Steps:
1. Enable one currently available add-on: `24-Hour New Receiver Delay` or `24-Hour Large Transfer Delay`.

Expected:
- transaction flow completes,
- add-on appears as enabled in UI,
- no contradictory status between modal and dashboard.

Severity: Critical

#### TC-C4 Add-on persistence after refresh
Steps:
1. After enabling add-on, reload app and reconnect.

Expected:
- enabled add-on remains enabled and visible.

Severity: Critical

### D. Send / Receive

#### TC-D1 Receive: copy vault address
Steps:
1. Open `Receive`.
2. Copy address.

Expected:
- copied address matches active vault address.

Severity: Critical

#### TC-D2 Receive: payment request URI generation
Steps:
1. Generate request URI with valid amount.

Expected:
- URI is generated in valid format,
- invalid input is rejected with clear error.

Severity: Major

#### TC-D3 Receive: direct send guard (insufficient signer balance)
Steps:
1. In direct-send path, enter amount above signer balance.

Expected:
- UI blocks send before submission,
- clear error explains insufficient balance / fee coverage.

Severity: Critical

#### TC-D4 Send immediate allow path
Steps:
1. Send a low-risk transfer expected to be allowed immediately.

Expected:
- transaction is executed without queueing,
- success result is shown.

Severity: Blocker

#### TC-D5 Send delayed path -> queue entry
Steps:
1. Trigger action expected to be delayed by active policy.

Expected:
- UI clearly communicates delay outcome,
- transaction appears in queue with unlock information.

Severity: Critical

#### TC-D6 Duplicate-submit protection
Steps:
1. During pending send/queue operation, click action multiple times.

Expected:
- duplicate submissions are blocked,
- no accidental double action is broadcast.

Severity: Critical

### E. Queue Lifecycle

#### TC-E1 Queue empty state
Steps:
1. Open queue when no items exist.

Expected:
- clear empty state,
- no stale error/loading spam.

Severity: Major

#### TC-E2 Queue delayed item visibility
Steps:
1. Open queue after scheduling delayed action.

Expected:
- item appears with status and unlock ETA/readiness.

Severity: Critical

#### TC-E3 Execute when unlocked
Steps:
1. Wait until queued tx is unlocked.
2. Execute from queue UI.

Expected:
- execution succeeds,
- queue item resolves/disappears appropriately.

Severity: Critical

#### TC-E4 Cancel queued action
Steps:
1. Create delayed item.
2. Cancel it from queue UI.

Expected:
- cancel flow succeeds,
- item state updates correctly.

Severity: Critical

### F. Queue Bot UX Path

#### TC-F1 Enable bot for vault
Steps:
1. Open Queue modal -> Automation Bot.
2. Enable bot.

Expected:
- wallet signs `setQueueExecutor(relayer, true)`,
- UI shows enabled state for this vault.

Severity: Critical

#### TC-F2 Disable bot for vault
Steps:
1. Disable bot from same panel.

Expected:
- wallet signs `setQueueExecutor(relayer, false)`,
- UI shows disabled state.

Severity: Critical

#### TC-F3 Bot status degradation handling
Steps:
1. With temporary bot/API unavailability (or simulated failure), open bot panel.

Expected:
- clear actionable error,
- app remains usable for manual queue management.

Severity: Major

### G. Resilience and Recovery

#### TC-G1 App reload with active vault
Steps:
1. With connected wallet and active vault, refresh page.

Expected:
- app restores consistent state,
- no contradictory status across modules.

Severity: Major

#### TC-G2 Transient RPC degradation behavior
Steps:
1. Trigger temporary RPC disruption (if possible in test environment).

Expected:
- UI shows fallback/retry messaging,
- critical controls do not produce unsafe ambiguous state.

Severity: Critical

## 7) Minimum Launch Pass Set
Launch should not proceed unless all cases below pass:
- `TC-A1` `TC-A2` `TC-A3` `TC-A4`
- `TC-B1` `TC-B2` `TC-B4`
- `TC-C3`
- `TC-D4` `TC-D5` `TC-D6`
- `TC-E3` `TC-E4`
- `TC-F1` `TC-F2`

## 8) Notes for External Tester
- Record wallet address used for each run.
- Attach tx hashes for create/send/queue/bot-toggle actions.
- If a case fails because of environmental outage (RPC, wallet extension, VPS), mark as:
  - `BLOCKED (environment)` and provide evidence.
