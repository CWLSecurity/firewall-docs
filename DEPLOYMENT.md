# Firewall Vault — Deployment (Current)

Last updated: 2026-03-25

## What this file covers
This document is the cross-repo deployment map.
It explains what must be deployed in each repository:
- `firewall-wallet` (on-chain contracts)
- `firewall-ui` (web app)
- `firewall-connector` (EIP-1193 package)

## Deployment Scope by Repository

Current release sequencing:
- MVP production rollout uses `firewall-wallet` + `firewall-ui`.
- `firewall-connector` deployment is explicitly post-MVP.

### 1) `firewall-wallet` (on-chain)
Deploy and wire:
- policy contracts,
- `PolicyPackRegistry` with curated base/add-on packs,
- entitlement manager,
- `PolicyRouterDeployer`,
- `FirewallFactory` bound to registry + entitlement manager + router deployer.

Wallet creation entrypoint:
- `createWallet(owner, recovery, basePackId)`
- creation is owner-authenticated (`msg.sender == owner`)
- entrypoint is payable and can seed initial Vault bot gas buffer

Current curated packs:
- Base `0`: Conservative (`Vault Safe` in UI)
- Base `1`: DeFi Trader
- Add-on `2`: Approval Hardening
- Add-on `3`: New Receiver 24h Delay
- Add-on `4`: Large Transfer 24h Delay

Current add-on semantics:
- enabled later through router, subject to entitlement mode,
- additive only,
- snapshotted to wallet router state,
- no disable path in current router line.

Policy metadata required for admitted policies:
- `policyKey`
- `policyName`
- `policyDescription`
- `policyConfigVersion`
- `policyConfig`

Large-transfer config shape:
- `ETH_THRESHOLD_WEI`
- `ERC20_THRESHOLD_UNITS` (raw token units)
- `DELAY_SECONDS`

Selector scope remains intentionally narrow:
- native ETH value
- ERC20 `transfer`
- ERC20 `transferFrom`

### 2) `firewall-ui` (frontend)
Static app deployment.

Recommended hosting:
- Cloudflare Pages
- Vercel
- Netlify

Build:
```bash
cd firewall-ui
pnpm install
pnpm build
```
Artifact:
- `firewall-ui/dist`

Operational notes:
- Base-only network requirement (current product stage).
- SPA routing should be configured correctly in hosting.
- Cache headers should allow safe roll-forward/rollback.

Queue bot server:
- run `npm run bot:server` from `firewall-ui`.
- requires:
  - `BASE_RPC_URL`
  - `RELAYER_PRIVATE_KEY` (or `DEPLOYER_PK` fallback)
- queue bot API endpoints are served from `/api/v1/bot/*`.
- UI Queue modal uses these endpoints to enable/disable per-Vault automation.
- queued tx without reserve are skipped by relayer script.

### 3) `firewall-connector` (integration package)
Library/package deployment model, not a standalone wallet UI.

Deployment means:
- publish package version,
- publish docs/integration examples,
- integrate in partner apps/wallet-adjacent flows.

Current maturity:
- Base-first connector boundary.
- Planned post-MVP stage (not on critical MVP release path).

## Network scope (current)
- Production target: Base Mainnet.
- Multi-network expansion requires per-network contract deployment + per-app config updates.

## Canonical operational references
Contract deployment and verification details:
- `../firewall-wallet/DEPLOYMENT.md`
- `../firewall-wallet/VERIFY_DEPLOYMENT.md`
- `../firewall-wallet/DEPLOYMENT_STATUS.md`

UI delivery details:
- `../firewall-ui/README.md`

Connector details:
- `../firewall-connector/README.md`
