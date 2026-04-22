# Firewall Vault — Deployment (Current MVP Automation)

Last updated: 2026-04-22

## Purpose
Canonical cross-repo deployment process for MVP.

## MVP Scope
- In scope: `firewall-wallet`, `firewall-ui`, bot runtime, `PROJECT_HOME` docs.
- Out of scope for MVP: `firewall-connector` deploy/release track.
- MVP production rollout uses `firewall-wallet` + `firewall-ui`.
- `firewall-connector` remains a post-MVP rollout track.
- External audit is deferred until post-pilot stage.

## 1) Wallet (`firewall-wallet`)
Target chain: Base Mainnet.

Automatic release path from local operator machine:
1. Quality/security gates run first:
   - `npm run integrity:check`
   - `npm run security:static`
   - `npm run test:contracts`
   - `npm run smoke:contracts`
   - launch e2e smoke includes `packages/contracts/test/smoke/V2EndToEndLaunchFlows.t.sol`
2. On-chain deploy runs from this machine:
   - `npm run deploy:base`
   - script path: `../firewall-wallet/scripts/deploy-base-mainnet.sh`
3. Post-deploy sync is automatic:
   - reads `packages/contracts/deployments/base-mainnet-manifest.json`
   - updates `../firewall-ui/src/contracts/addresses/base.ts`
   - refreshes `../firewall-ui/integrity/manifest.sha256`
4. Then commit/push changed repos (`firewall-wallet`, `firewall-ui`) using their own release flow.
5. For bot-enabled vaults, run readiness preflight:
   - `BASE_RPC_URL=... VAULT_ADDRESS=0x... RELAYER_ADDRESS=0x... npm run bot:readiness:check`

Address-sync script:
- `../firewall-wallet/scripts/sync-ui-addresses-from-manifest.sh`

## 2) UI (`firewall-ui`)
Primary production path: GitHub push -> GitHub Actions -> Cloudflare Pages.

Quality/security gates:
- `npm run lint`
- `npm run security:static`
- `npm test`
- `npm run test:bot:e2e`
- `npm run smoke`
- `npm run integrity:check`

GitHub workflows:
- `.github/workflows/ci.yml` (`lint`, `security:static`, `test`, `test:bot:e2e`, `smoke`, `integrity:check`)
- `.github/workflows/deploy-cloudflare-pages.yml` (build + Cloudflare Pages deploy on `main`)

Required GitHub config:
- secret `CLOUDFLARE_API_TOKEN`
- secret `CLOUDFLARE_ACCOUNT_ID`
- variable `CF_PAGES_PROJECT_NAME`

Domains:
- `firewall-wallet.com`
- `www.firewall-wallet.com`

## 3) Bot Runtime (remote server)
Bot code is deployed from local machine (not from GitHub bot workflow).

Deploy command:
- `cd ../firewall-ui && npm run bot:deploy:remote`

Before remote deploy (automatic in script by default):
- `npm run lint`
- `npm run security:static`
- `npm test`
- `npm run test:bot:e2e`
- `npm run smoke`
- `npm run integrity:check`

Bot API hardening requirements:
- do not use `BOT_ALLOW_UNSAFE_REMOTE=true` in internet-facing runtime,
- use `BOT_API_TOKEN` for remote mutation authorization,
- for UI mutation calls, store operator token in browser storage:
  - `sessionStorage.setItem('firewall.botApiToken', '<token>')`
  - fallback key: `localStorage.setItem('FIREWALL_BOT_API_TOKEN', '<token>')`
- bot deploy script fails if health reports `mutationAuthMode=unsafe-remote` (unless explicitly overridden).

Remote deploy script:
- `../firewall-ui/scripts/deploy-bot-remote.sh`

Health endpoint:
- `https://bot.firewall-wallet.com/api/v1/bot/health`

## 4) Extension (`firewall-connector`)
- Ignored for MVP rollout.
- Separate post-MVP track.

## 5) PROJECT_HOME (docs repo)
Purpose: cross-repo docs and operator runbooks.

Checks before push:
- required docs presence
- docs integrity manifest check (`./scripts/integrity.sh check`)
- content-audit guardrails (via ops scripts)

Then push docs updates to GitHub.

## Secrets policy
- Tokens/keys stay in local machine environment or GitHub Secrets only.
- `.env*`, private keys, token values must not be committed to git.
- Repo `.gitignore` rules enforce local secret file exclusion.

## GitHub CI/CD inventory (expected, MVP)
- `firewall-wallet`: `Firewall Wallet CI`
- `firewall-ui`: `Firewall UI CI`, `Firewall UI Deploy (Cloudflare Pages)`
- `firewall-docs` (`PROJECT_HOME`): `PROJECT_HOME Docs CI`
- `firewall-connector`: no active workflow in MVP
