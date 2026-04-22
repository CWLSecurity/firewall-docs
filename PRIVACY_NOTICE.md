# Firewall Vault — Privacy Notice (Pilot)

Last updated: 2026-04-22

## 1) Product-side data handling
Current UI architecture is designed to avoid product-side analytics telemetry by default.

Documented behavior:
- no analytics SDK in app code,
- no persistent site-side business-state storage by default.

Reference:
- `../firewall-ui/README.md` (`Privacy and Data Handling` section).

## 2) Data visible to third parties
Even with privacy-focused defaults, interactions may be visible to:
- blockchain RPC providers,
- wallet extension providers,
- blockchain explorers (public on-chain data).

## 3) Bot runtime data
Queue bot runtime stores operational state for enabled vaults:
- enable/disable state,
- last run status,
- last error/output snippets.

Default file path:
- `../firewall-ui/server/state/bot-vaults.json`

## 4) Secrets handling
Private keys and tokens must be stored in environment/secrets managers and must not be committed to git.

## 5) Contact
Security/privacy inquiries:
- `security@firewallvault.io`
