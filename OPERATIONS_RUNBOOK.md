# Firewall Vault — Operations Runbook (Pilot)

Last updated: 2026-04-22

## 1) Current launch mode
- Stage: pilot / controlled rollout.
- External audit: not completed yet (explicitly accepted for pilot stage).
- Scope: `firewall-wallet` + `firewall-ui` + bot runtime.

## 2) Release sequence (operator)
1. Wallet release from local machine:
   - `cd ../firewall-wallet`
   - `npm run deploy:base`
2. Address sync verification:
   - confirm `../firewall-ui/src/contracts/addresses/base.ts` updated.
   - `cd ../firewall-ui && npm run integrity:check`
3. UI release:
   - push `firewall-ui/main`
   - confirm both workflows green (`UI CI`, `UI Deploy`).
4. Bot release from local machine:
   - `cd ../firewall-ui && npm run bot:deploy:remote`

## 3) Bot hardening requirements (production/pilot internet)
- Use `BOT_API_TOKEN` for remote bot API mutations.
- Keep `BOT_ALLOW_UNSAFE_REMOTE` disabled.
- If binding bot server to non-loopback host, startup requires `BOT_API_TOKEN`.
- Deploy script must fail if health reports `mutationAuthMode=unsafe-remote`.

## 4) Bot readiness checks per Vault
Before enabling continuous automation for a Vault:
```bash
cd ../firewall-wallet
BASE_RPC_URL=... \
VAULT_ADDRESS=0x... \
RELAYER_ADDRESS=0x... \
MIN_BOT_GAS_BUFFER_WEI=... \
npm run bot:readiness:check
```

Expected pass conditions:
- relayer is authorized in vault (`isQueueExecutor == true`),
- `autoReserveWei > 0`,
- refund caps are non-zero,
- optional minimum bot gas buffer is satisfied.

## 5) Runtime health checks
- UI site:
  - `https://firewall-wallet.com`
- Bot API:
  - `https://bot.firewall-wallet.com/api/v1/bot/health`
- Validate health payload:
  - `ok: true`
  - `runtime.hasBaseRpc: true`
  - `runtime.hasRelayerKey: true`
  - `security.mutationAuthMode` should be `token` (or `local-only` for localhost-only mode)

## 6) Incident procedure (minimal)
1. Contain:
   - disable bot per affected vault from UI, or revoke executor on-chain.
2. Triage:
   - collect bot logs (`lastError`, `lastOutput`, server logs),
   - verify on-chain queue/executor state.
3. Recover:
   - fix root cause,
   - re-run readiness checks,
   - re-enable automation.
4. Communicate:
   - post incident note in project channel and update runbook if needed.

## 7) Explicit non-goals in this stage
- No claim of complete risk elimination.
- No claim of full dApp compatibility.
- No claim of audited-final security posture yet.
