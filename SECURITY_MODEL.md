# Firewall Vault — Security Model (MVP)

## Core (wallet) guarantees (from wallet context)
- Non-custodial
- Enforcement on-chain
- Policies allow/delay/revert
- Delay queue enforced on-chain
- No off-chain policy logic

## UI behavior
- UI never stores private keys
- Signs via MetaMask
- Stateless except localStorage
- Read-only mode safe

## Assumptions
- User controls EOA
- RPC trust for reads

## Risks / Limitations
- Not audited (if true)
- UI supply chain risk
- Browser wallet compromise
- Delays can block actions temporarily
- Queue lookback limitations (200k blocks)
