# Firewall Vault — Launch Status (Pilot Go-Live)

Last updated: 2026-04-28

## Current state
- `firewall-ui`: deployed to Cloudflare Pages (`firewall-wallet.com`, `www.firewall-wallet.com`).
- Bot runtime: deployed on VPS and reachable via `bot.firewall-wallet.com`.
- Deployment model: documented across repos (`wallet` local deploy, `ui` GitHub->Pages, `bot` local->VPS).
- Current live/deploy pack truth:
  - Base `0`: Vault / Conservative
  - Base `1`: DeFi Trader
  - Add-on `2`: 24-Hour New Receiver Delay
  - Add-on `3`: 24-Hour Large Transfer Delay
- Current live Base `0` has two active base policies: `LargeTransferDelayPolicy` and `NewReceiverDelayPolicy`.
- `InfiniteApprovalPolicy` is deployed and present in code, but it is not active in current live Base `0` and there is no live Approval Hardening add-on pack.
- Launch policy decision: launch the current simplified 4-pack line (`Vault` with 2 default policies, `DeFi Trader`, plus add-ons `2` and `3`). No policy redeploy is planned for this launch.
- Handoff docs for dev team: added in all repos.
- Bot auth hardening exists in current `firewall-ui` code:
  - UI supports token header for bot mutation endpoints via browser storage keys,
  - bot auth model has dedicated e2e tests in `firewall-ui` CI (`test:bot:e2e`).
- Live bot runtime check currently fails the production auth gate because health does not expose `security.mutationAuthMode`.
- Wallet smoke coverage expanded with launch e2e flow scenarios (`V2EndToEndLaunchFlows.t.sol`).

## Must-do before launch

### P0 policy decision: launch current 4-pack line
Decision:
- live registry and manifest are aligned on 4 packs (`0,1,2,3`);
- launch scope is the current simplified model: `Vault` Base `0`, `DeFi Trader` Base `1`, add-on `2`, add-on `3`;
- conservative large-transfer thresholds are no longer `0` in the current manifest;
- current live Base `0` does not include strict approval hardening;
- no policy redeploy is planned for this launch.

I should not redeploy policies without a new explicit approval.

If a stricter line is required after launch, the implementation path is:
1. Change deploy scripts and smoke/fork fixtures to one canonical pack lineup.
2. Run wallet contract tests and smoke tests.
3. Dry-run Base deployment.
4. Broadcast only after explicit approval.
5. Sync UI addresses from the new manifest.
6. Re-run UI/build/integrity and on-chain verification.

### P1: final live security semantics check
- Validate live behavior for:
  - `REVERT > DELAY > ALLOW`,
  - `executeScheduled` re-checks current policy,
  - large-transfer boundaries: below/equal/above threshold.
- Validate current approval behavior without overclaiming strict Base `0` approval protection.

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
  - `security.mutationAuthMode` is present,
  - expected production value is `token` (not `unsafe-remote` and not missing).
- Queue modal bot mutation checks pass in production mode with token-protected server
  (`enable`, `disable`, `run`).
- Rollback/escalation contacts confirmed.

## Launch decision rule
Go-live is allowed only after P0 is completed and all P1 items are green.
