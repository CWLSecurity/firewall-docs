# Firewall Vault — Launch Checklist (Current)

Last updated: 2026-03-25

## 1) Deployment and Verification
- MVP scope freeze confirmed:
  - in-scope: `firewall-wallet` + `firewall-ui`,
  - out-of-scope until next phase: `firewall-connector` rollout.
- Confirm deployed addresses and explorer verification are published.
- Confirm curated packs are registered and active:
  - Base `0` / Base `1`
  - Add-ons `2`, `3`, `4`
- Confirm policy metadata introspection values (`policyKey`, `policyName`, `policyConfigVersion`, config entries) for all active pack policies.

## 2) Security Semantics Validation
- Router decision priority validated on live deployment (`REVERT > DELAY > ALLOW`).
- `executeScheduled` current-policy recheck validated.
- Strict approval behavior validated on conservative line.
- DeFi line compensating controls validated (new spender/new recipient friction paths).
- Large-transfer threshold boundaries validated (`below`, `equal`, `above`).

## 3) UI Readiness
- Create/import Vault flows are stable on Base.
- Active protections and add-ons render readable business copy.
- Tooltips are concise and link to full policy catalog.
- Queue summary + queue modal execute/cancel flows are operational.
- Queue bot panel works:
  - enable path updates on-chain executor role,
  - disable path revokes role and disables server Vault run.
- `Disconnect Vault` does not auto-reconnect in background unless user explicitly creates/imports.

## 4) Reliability and Degradation
- Transient RPC degradation handling verified (fallback copy + retry behavior).
- No critical path depends on non-deterministic frontend-only policy logic.
- Known limitations are explicitly documented in user-facing docs.

## 5) Privacy and Storage
- Site-side business-state persistence disabled for wallet connection state.
- No analytics SDK or telemetry pipeline in app code.
- Public-facing copy clarifies external wallet/RPC logging trust boundary.

## 6) Product Messaging Consistency
- Messaging consistently states:
  - non-custodial signer model,
  - on-chain deterministic policy enforcement,
  - security-console role of UI.
- Avoid overclaims (no "guaranteed safety" messaging).

## 7) Ops and Release Hygiene
- Smoke pass complete on latest build.
- CI status green for:
  - `PROJECT_HOME` docs/integrity workflow
  - `firewall-ui` quality + smoke + integrity workflow
  - `firewall-wallet` contracts + smoke + integrity workflow
- Integrity manifests checked:
  - `PROJECT_HOME/integrity/manifest.sha256`
  - `firewall-ui/integrity/manifest.sha256`
  - `firewall-wallet/integrity/manifest.sha256`
- Incident/reporting path documented.
- Rollback owner/escalation contacts defined.
