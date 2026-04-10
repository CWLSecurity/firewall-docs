# Firewall Vault Marketing Brief

Last updated: 2026-03-23

This brief is intended for AI-assisted copywriting and campaign drafting.

## 1) Positioning
Firewall Vault is an on-chain transaction firewall for self-custody users on Base.

Short positioning line:
- "Self-custody wallet security with deterministic on-chain enforcement."

## 2) Core Problem We Solve
Users can sign risky transactions too quickly. Traditional warnings are often bypassed.

Firewall Vault adds enforceable control paths:
- allow immediately,
- delay for review,
- block by policy.

## 3) Product Components
- `firewall-wallet`: canonical smart contracts.
- `firewall-ui`: active security console for create/import/protection/queue.
- `firewall-connector`: EIP-1193 connector boundary for broader integration patterns.

## 4) Current User Value
- Non-custodial by design.
- Explicit protection lines (`Vault Safe`, `DeFi Trader`).
- Optional add-on packs for extra friction on risky actions.
- Queue controls for delayed actions (execute/cancel).
- Business-readable protection explanations backed by chain data.

## 5) Audience Segments
- Everyday self-custody users who want safer defaults.
- Active DeFi users who still want guardrails.
- Security-conscious communities/operators that value deterministic on-chain behavior.

## 6) Proof-Backed Claims (Use)
- "On-chain policy enforcement before execution."
- "Signer wallet keeps private keys."
- "Deterministic policy outcomes: allow, delay, or block."
- "Protection packs can be composed for stronger coverage."

## 7) Claims To Avoid (Do Not Use)
- "100% protection" or "guaranteed funds safety".
- "Works with every dApp flow today".
- "AI decides all transaction safety outcomes".
- "No one can see any transaction data".

## 8) Tone Guidance
Use:
- clear, factual, product-specific language
- confidence with constraints
- explicit mention of current scope (Base, current UX, current maturity)

Avoid:
- exaggerated security promises
- vague "military-grade" style language
- generic wallet marketing cliches disconnected from architecture

## 9) Reusable Copy Blocks
Headline options:
- "On-chain firewall for self-custody wallets."
- "Delay or block risky actions before funds move."
- "Security controls for Base wallets without giving up custody."

Short body option:
- "Firewall Vault adds deterministic on-chain protection to your wallet flow. Keep your keys, choose a protection line, and enforce delay/block rules before execution."

CTA options:
- "Protect My Wallet"
- "Create My Vault"
- "Explore Protection Lines"

## 10) Campaign Execution Phases
### Phase 1 — Trust and clarity
- Explain base packs vs add-ons.
- Explain deterministic decision model (`REVERT > DELAY > ALLOW`).
- Explain current limitations honestly.

### Phase 2 — DeFi usability clarity
- Show DeFi line behavior:
  - normal contract interactions remain usable,
  - risky first-spender/recipient flows are delayed/blocked by policy.

### Phase 3 — Connector direction
- Introduce connector direction as compatibility bridge.
- Be explicit that the core security model remains unchanged.

## 11) Campaign Metrics
- connects
- wallet creations
- queue actions (schedule/execute/cancel)
- add-on enablement
- first-time flow drop-offs
- support tickets grouped by confusion category (packs, delays, signer vs vault)

## 12) Canonical Sources Before Publishing
- `../firewall-wallet/README.md`
- `../firewall-wallet/PACK_MATRIX.md`
- `../firewall-ui/README.md`
- `../firewall-ui/UI_ARCHITECTURE.md`
