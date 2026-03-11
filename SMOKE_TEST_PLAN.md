# Firewall Vault — Smoke Test Plan (MVP)

## 1. Purpose

This smoke test validates that Firewall Vault MVP works end-to-end for the main user flows before production deployment.

Goal:

- confirm core product usability
- catch blocking bugs
- catch critical UX issues
- verify that main on-chain flows behave correctly

This is **not** a full QA cycle and **not** a security audit.

---

## 2. Scope

This smoke test covers:

- wallet connection
- network validation
- firewall wallet creation
- firewall wallet import
- ETH send flow
- delay flow
- execute scheduled transaction
- cancel scheduled transaction
- read-only mode
- diagnostics

Out of scope:

- deep edge-case testing
- performance benchmarking
- formal security validation
- cross-browser full regression matrix
- advanced DeFi interaction testing

---

## 3. Test Environment

Network: Base Mainnet  
chainId: 8453

Frontend:
- firewall-ui

Wallet:
- MetaMask or compatible EVM wallet

Browser:
- Chrome latest

Required:
- EOA with Base ETH for gas
- optional second address for transfers

---

## 4. Exit Criteria

Smoke test PASSED if:

- core flows work
- no blocker bugs
- no critical UX issues

FAILED if:

- wallet cannot connect
- firewall wallet cannot be created/imported
- send ETH broken
- delayed tx cannot execute/cancel
- wrong network not handled
- diagnostics misleading

---

## 5. Severity Levels

Blocker — product unusable  
Critical — core flow incorrect or dangerous  
Major — strong UX friction  
Minor — cosmetic issue

---

## 6. Tests

### T1 App Load

Open app and confirm UI renders.

Expected:
- no blank screen
- actions visible

Severity if fail: Blocker

---

### T2 Connect Wallet

Connect wallet and verify address appears.

Expected:
- wallet connected
- address shown
- UI updates

Severity: Blocker

---

### T3 Wrong Network

Switch wallet to non-Base network.

Expected:
- app warns about wrong network
- actions disabled

Severity: Critical

---

### T4 Create Firewall Wallet

Create firewall wallet from UI.

Expected:
- tx submitted
- wallet created
- UI shows wallet address

Severity: Blocker

---

### T5 Import Firewall Wallet

Import existing firewall wallet.

Expected:
- wallet loads
- state visible

Severity: Blocker

---

### T6 Read-Only Mode

Inspect wallet without executing actions.

Expected:
- data visible
- no broken UI

Severity: Major

---

### T7 Send ETH (Allow Flow)

Send small ETH amount.

Expected:
- tx executes immediately
- success shown
- balance refresh

Severity: Blocker

---

### T8 Send ETH (Delay Flow)

Send amount triggering delay.

Expected:
- tx appears in delayed queue
- not executed immediately

Severity: Critical

---

### T9 Delayed Queue

Open delayed queue.

Expected:
- queued tx visible
- details understandable

Severity: Critical

---

### T10 Execute Scheduled

Execute delayed tx.

Expected:
- tx executes
- queue updates

Severity: Blocker

---

### T11 Cancel Scheduled

Cancel delayed tx.

Expected:
- tx cancelled
- queue updates

Severity: Blocker

---

### T12 Diagnostics

Open diagnostics page.

Expected:
- network and config visible
- no false status

Severity: Critical

---

### T13 Error Handling

Reject wallet signature.

Expected:
- UI recovers
- no frozen state

Severity: Major

---

## 7. Time Budget

Total time: 30–40 minutes

---

## 8. Result

PASS — no blocker or critical issues  
PASS WITH ISSUES — only major/minor issues  
FAIL — blocker or critical issues found
