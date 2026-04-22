# Firewall Vault — Cross-Repo Developer Handoff

Last updated: 2026-04-22

This document defines how a new engineering team should operate the full MVP stack.

## 1. Repositories and ownership
- `firewall-wallet`: canonical contracts, deployment artifacts, address source of truth.
- `firewall-ui`: user-facing app + Cloudflare Pages deploy + bot runtime tooling.
- `PROJECT_HOME`: launch policy, runbooks, legal/comms docs, release checklist.

## 2. Current release model
- Wallet deploy: local operator machine -> Base.
- UI deploy: push to GitHub -> Cloudflare Pages workflow.
- Bot deploy: local operator machine -> VPS (`bot.firewall-wallet.com`).
- Extension: out of MVP scope.

## 3. Standard operator sequence
1. Implement change in relevant repo.
2. Run local quality/security gates for that repo.
3. Deploy wallet when contracts changed.
4. Verify UI addresses synced from wallet deploy.
5. Push repos to remote Git (without secrets/service artifacts).
6. Verify CI status.
7. Execute bot remote deploy from local machine when bot/runtime changed.

## 4. Mandatory security hygiene
- Secrets are stored only in local machine env/secret stores and GitHub Secrets where needed.
- No private keys, tokens, `.env`, raw server credentials, or ad-hoc ops dumps in Git.
- Bot mutation endpoints must not run in unsafe remote mode for internet-facing deployment.

## 5. MVP acceptance checks
- Wallet tests and smoke tests pass.
- UI quality, tests, smoke, integrity checks pass.
- Bot health endpoint returns healthy runtime and secure auth mode.
- Launch checklist (`LAUNCH_CHECKLIST.md`) has no open blockers except explicitly accepted pilot exceptions.

## 6. Fast onboarding checklist for new engineers
- Read in this order:
  1. `ARCHITECTURE.md`
  2. `DEPLOYMENT.md`
  3. `BOT_AUTOMATION.md`
  4. `OPERATIONS_RUNBOOK.md`
  5. `LAUNCH_CHECKLIST.md`
- Then open repo-local handoff docs:
  - `../firewall-wallet/DEV_HANDOFF.md`
  - `../firewall-ui/DEV_HANDOFF.md`

## 7. Change management rule
If change affects runtime behavior, update:
- code/tests,
- relevant runbook,
- launch checklist item (if applicable),
- release notes/commit message with operational impact.
