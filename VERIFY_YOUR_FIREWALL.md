# Firewall Vault — Verify Your Firewall

## Purpose
This document helps users verify that the protection they see is real and corresponds to the intended Firewall Vault deployment.

## What to verify
Users should verify:

- the correct contract addresses
- verified source code
- expected ownership and wallet relationships
- that execution goes through FirewallModule
- that they are using the intended frontend and repositories

## 1. Verify contract addresses
Check the published addresses for:
- FirewallFactory
- PolicyRouter
- active policy contracts
- your FirewallModule instance

Compare them with:
- the official repository documentation
- the UI display
- block explorer pages

## 2. Verify source code on explorer
On BaseScan, verify that:
- contracts are verified
- source code is readable
- contract names match expectations
- deployed code corresponds to the intended modules

## 3. Verify there is no unexpected proxy behavior
Users should confirm whether the deployment matches the intended architecture and does not rely on unexpected proxy indirection.

Practical check:
- inspect contract pages on the explorer
- inspect verified source
- inspect constructor/setup patterns
- compare with public architecture docs

## 4. Verify wallet ownership
Users should verify that the Firewall wallet they created or imported is actually their intended wallet and is configured for their ownership expectations.

Practical checks may include:
- reading owner-related state if exposed
- confirming wallet address shown in the UI
- confirming the creating transaction on explorer
- confirming the wallet belongs to the intended user flow

## 5. Verify execution path
A user should confirm that transactions are not bypassing the FirewallModule.

Practical signs:
- transactions originate through the intended wallet execution flow
- queue-related activity is visible on-chain when delay is triggered
- transaction history corresponds to FirewallModule-based execution

## 6. Verify frontend sources
Users should verify:
- the public GitHub repositories
- the documented product structure
- the public README and security docs
- that the UI they use corresponds to the intended published project

## 7. Understand current limitations
Before trusting the system, users should confirm:
- MVP stage
- audit status
- Base-only scope
- no ERC20 UI in MVP
- queue lookback limitations in UI

## Summary checklist
Before using Firewall Vault with meaningful funds:

- verify contract addresses
- verify explorer source code
- verify the intended wallet and ownership path
- verify transaction flow goes through FirewallModule
- verify audit status and MVP limitations
- verify you are using the intended frontend
