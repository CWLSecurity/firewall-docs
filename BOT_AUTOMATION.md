# Firewall Vault — Queue Bot Automation

Last updated: 2026-03-25

## Purpose
Cross-repo reference for delayed queue auto-execution.

## Current model
- Owner authorizes relayer per Vault on-chain:
  - `setQueueExecutor(relayer, true|false)` in `FirewallModule`.
- Bot runtime uses relayer key only.
- Bot executes unlocked queue actions via:
  - `executeScheduledByExecutor(txId)`.
- Owner key is not stored or used in bot server runtime.

## Gas model
- Vault maintains bot gas pool accounting.
- Pool is commonly funded at Vault creation (`createWallet` payable path) and can be topped up later.
- `schedule(...)` auto-reserves per-tx execution budget from bot pool.
- Relayer script skips queued tx with zero reserve.
- Relayer pays gas up-front and gets refunded from tx reserve (with contract-side caps).

## Repositories
- `../firewall-wallet`
  - executor role + reserve/refund logic + relayer script (`RunQueueRelayer.s.sol`).
- `../firewall-ui`
  - Queue modal bot panel + server runtime (`server/queue-bot-server.mjs`).
- `PROJECT_HOME`
  - cross-repo runbook and security assumptions.

## User flow
1. Connect wallet and select Vault in UI.
2. Open `Queue` -> `Automation Bot`.
3. Click `Enable Bot`:
   - wallet signs `setQueueExecutor(relayer, true)`,
   - UI enables this Vault in bot server API.
4. Bot loop checks this Vault and executes unlocked delayed actions.
5. Disable with `Disable Bot`:
   - wallet signs `setQueueExecutor(relayer, false)`,
   - server Vault automation is disabled.

## Server API summary
- `GET /api/v1/bot/health`
- `GET /api/v1/bot/vaults`
- `GET /api/v1/bot/vault/:vault/status`
- `POST /api/v1/bot/vault/:vault/enable`
- `POST /api/v1/bot/vault/:vault/disable`
- `POST /api/v1/bot/vault/:vault/run`

## Security constraints
- Bot cannot execute before unlock; contract enforces unlock checks.
- Unauthorized callers are rejected by `onlyQueueExecutor`.
- Revocation is owner-controlled and immediate on-chain.
- Bot key compromise does not reveal owner key.

## Operational notes
- Run bot server in trusted environment.
- Mutating API endpoints should be local-only or protected with `BOT_API_TOKEN`.
- Keep relayer key only in secrets manager/env, never in repo files.
