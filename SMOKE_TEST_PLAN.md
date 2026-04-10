# Firewall Vault — Smoke Test Plan (Active Modular UI)

Last updated: 2026-03-25

## 1. Purpose
Validate launch-critical user flows in the active modular dashboard (`src/App.tsx` + `src/modules/*`) before production rollout.

This is a launch smoke test, not a full QA cycle and not a security audit.

## 2. Scope
In scope:
- connect / network gate
- wallet discovery
- create wallet flow
- dashboard module visibility
- transactions + delayed queue
- queue bot enable/disable flow
- packs visibility
- diagnostics behavior

Out of scope:
- deep cross-browser matrix
- performance benchmarking
- formal contract security validation

## 3. Test Environment
- Network: Base Mainnet (`8453`)
- Frontend: `firewall-ui`
- Wallet: MetaMask or compatible injected wallet
- Browser: latest Chrome
- Test funds: small Base ETH for gas and transfer tests

## 4. Exit Criteria
PASS:
- no blocker or critical issues in active flows
- correct state-driven module visibility
- no stale or contradictory status messaging

FAIL:
- create wallet flow broken
- queue management broken
- wrong network gate broken
- dashboard state transitions broken

## 5. Severity
- Blocker: product unusable
- Critical: core security/control flow incorrect
- Major: significant UX friction
- Minor: cosmetic/documentation mismatch

## 6. Test Cases

### T1 App load
Expected:
- page renders
- connect area visible when disconnected
- diagnostics collapsed

Severity on fail: Blocker

### T2 Connect wallet
Expected:
- address shown
- chain status shown
- wrong-network warning shown if non-Base

Severity: Blocker

### T3 Connected, no Firewall Wallet found
Expected:
- Wallet Summary visible
- Create Firewall Wallet visible
- messaging explains discovery/retry/manual path

Severity: Critical

### T4 Create wallet (happy path)
Action:
- select Security Mode/Base Pack
- submit create transaction

Expected:
- pending state clear
- duplicate-click prevented while pending
- success state shows created Firewall Wallet
- dashboard refreshes into wallet-created state

Severity: Blocker

### T5 Create wallet (reject/failure)
Action:
- reject signature or force RPC failure

Expected:
- clear failure message
- UI remains usable for retry
- no frozen pending state

Severity: Critical

### T6 Wallet-created dashboard state
Expected visible modules:
- Wallet Summary
- Security
- Transactions
- Queue
- Security Packs
- Diagnostics collapsed

Severity: Blocker

### T7 Queue empty state
Expected:
- queue area visible
- clear empty-state copy
- no error spam

Severity: Major

### T8 Queue populated state
Action:
- schedule delayed tx

Expected:
- tx appears in queue
- execute/cancel action buttons behave correctly
- pending/confirming protection against duplicate action submits

Severity: Critical

### T9 Packs area visibility
Expected:
- base packs shown
- optional add-on pack section shown
- entitlement state labels shown (available/locked/unknown)

Severity: Major

### T10 Queue bot enable/disable
Action:
- open Queue modal -> Automation Bot panel
- enable bot for selected Vault
- disable bot for selected Vault

Expected:
- on enable: wallet signs `setQueueExecutor(..., true)` and server status becomes enabled
- on disable: wallet signs `setQueueExecutor(..., false)` and server status becomes disabled
- queued tx without reserve are not expected to auto-execute by bot
- informative errors shown if bot server is unavailable

Severity: Critical

### T11 Diagnostics behavior
Expected:
- diagnostics collapsed by default
- technical details available only on expand

Severity: Major

## 7. Known limitations to validate and communicate
- Wallet discovery is log-based and bounded by factory lookback window.
- Queue discovery is log-based and bounded by queue lookback window.
- Add-on pack discovery is candidate-ID based pending richer on-chain enumeration.

## 8. Time Budget
~30–45 minutes for one complete pass.

## 9. Result Format
- PASS
- PASS WITH ISSUES (major/minor only)
- FAIL (any blocker/critical)

## 10. Automated Smoke Entry Points
- UI smoke suite:
  - `cd ../firewall-ui && npm run test:smoke`
  - `cd ../firewall-ui && npm run smoke`
- Contracts smoke suite:
  - `cd ../firewall-wallet && npm run smoke:contracts`
