# Firewall Vault — Release Notes v0.1 (MVP)

## Release Type
MVP (Proof of concept, production-deployable UI, not audited)

## Core (firewall-wallet)

- FirewallModule (Smart Account)
- PolicyRouter (per-wallet routing)
- Policies:
  - InfiniteApprovalPolicy
  - LargeTransferDelayPolicy
  - NewReceiverDelayPolicy
  - UnknownContractBlockPolicy
- Presets:
  - Conservative
  - DeFi Trader
- Delayed transaction queue (schedule / executeScheduled / cancelScheduled)
- Fully on-chain enforcement
- No custody
- No backend

Deployed on:
Base (chainId 8453)

--------------------------------------

## UI (firewall-ui)

Features:

- Wallet connect (MetaMask / injected)
- Create firewall wallet (preset 0/1)
- Import existing firewall wallet
- Read-only mode
- Send ETH via FirewallModule.executeNow
- Delayed queue:
  - List scheduled tx
  - Execute when ready
  - Cancel
- Explorer links (BaseScan)
- Copy buttons
- Diagnostics panel

Architecture:

- Vite + React + TypeScript
- viem + wagmi
- No backend
- No database
- Stateless except localStorage

--------------------------------------

## What is NOT included

- No audit
- No ERC20 UI
- No calldata decoding
- No multisig UI
- No upgrade logic
- No analytics backend
- No policy editor UI

--------------------------------------

## Known Limitations

- Queue lookback limited (200k blocks)
- Imported wallet preset may be unknown
- Contracts not audited
- User is responsible for private key security

--------------------------------------

## Intended Use

- Early adopters
- Power users
- Security-focused DeFi users
- Testing and feedback collection

--------------------------------------

## Next Milestones (Post-MVP)

- ERC20 send support
- Better queue visualization
- Policy customization UI
- Contract audit
- L2 expansion

--------------------------------------
