# Firewall Vault — Launch Status (Pilot Go-Live)

Last updated: 2026-04-22

## Current state
- `firewall-ui`: deployed to Cloudflare Pages (`firewall-wallet.com`, `www.firewall-wallet.com`).
- Bot runtime: deployed on VPS and reachable via `bot.firewall-wallet.com`.
- Deployment model: documented and aligned across repos (`wallet` local deploy, `ui` GitHub->Pages, `bot` local->VPS).
- Handoff docs for dev team: added in all repos.
- Bot auth hardening update shipped:
  - UI supports token header for bot mutation endpoints via browser storage keys,
  - bot auth model has dedicated e2e tests in `firewall-ui` CI (`test:bot:e2e`).
- Wallet smoke coverage expanded with launch e2e flow scenarios (`V2EndToEndLaunchFlows.t.sol`).

## Must-do before launch

### P0 blocker: switch conservative large-transfer threshold from test mode to production
Current state (test mode):
- conservative threshold defaults to `0` in deploy scripts:
  - `../firewall-wallet/packages/contracts/script/DeployBaseMainnet.s.sol`
  - `../firewall-wallet/packages/contracts/script/DeployFactoryBaseMainnet.s.sol`

Production target:
- `LARGE_TRANSFER_THRESHOLD_WEI = 50000000000000000` (`0.05 ETH`)
- `LARGE_TRANSFER_ERC20_THRESHOLD_UNITS = 50000000000000000` (raw units baseline)

Required actions:
1. Run wallet release with production threshold envs.
2. Redeploy contracts on Base (`npm run deploy:base`).
3. Auto-sync addresses into `firewall-ui`.
4. Re-run wallet and ui quality gates.
5. Verify on-chain config/metadata and publish final addresses.

Done criteria:
- no conservative pack with threshold `0` in active production deployment,
- deployment artifacts reflect production threshold,
- UI policy surfaces are consistent with on-chain values.

### P1: final live security semantics check
- Validate live behavior for:
  - `REVERT > DELAY > ALLOW`,
  - `executeScheduled` re-checks current policy,
  - large-transfer boundaries: below/equal/above threshold.

### P1: bot readiness for each launch vault
Run for each launch vault:
```bash
cd ../firewall-wallet
BASE_RPC_URL=... \
VAULT_ADDRESS=0x... \
RELAYER_ADDRESS=0x... \
MIN_BOT_GAS_BUFFER_WEI=... \
npm run bot:readiness:check
```
Pass conditions:
- relayer is authorized,
- bot gas config is non-zero,
- gas buffer meets minimum target.

### P1: final CI and ops sign-off
- Green CI in all MVP repos:
  - `firewall-wallet`: `Firewall Wallet CI`
  - `firewall-ui`: `Firewall UI CI`, `Firewall UI Deploy (Cloudflare Pages)`
  - `firewall-docs`: `PROJECT_HOME Docs CI`
- Bot health check reports secure mode:
  - `security.mutationAuthMode` is `token` (not `unsafe-remote`).
- Queue modal bot mutation checks pass in production mode with token-protected server
  (`enable`, `disable`, `run`).
- Rollback/escalation contacts confirmed.

## Launch decision rule
Go-live is allowed only after P0 is completed and all P1 items are green.
