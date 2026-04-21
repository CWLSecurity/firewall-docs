# Firewall Vault — Security Policy

Last updated: 2026-03-25

## Reporting a vulnerability
If you believe you found a security vulnerability in Firewall Vault, report it responsibly.

Do not disclose vulnerabilities publicly before triage.

Contact:
- `security@firewallvault.io`

Include:
- vulnerability description
- reproduction steps
- affected components/contracts
- impact assessment
- suggested mitigation (if known)

## Responsible disclosure
Researchers are asked to:
- avoid exploiting issues beyond proof of concept,
- avoid accessing or modifying user funds,
- provide reasonable time for triage and fix before disclosure.

## Scope
This policy applies to:
- `firewall-wallet`
- `firewall-ui`
- `firewall-connector`
- `PROJECT_HOME`

## Out of scope (typical)
- compromised user device/browser,
- stolen private keys/seed phrases,
- compromised third-party wallet extensions,
- incidents fully outside Firewall Vault code and infrastructure.

## Current security status
Firewall Vault is currently in MVP stage.

Current interpretation for users:
- treat the product as experimental software,
- assume contracts are not audited unless explicitly announced otherwise,
- verify addresses and source code before meaningful use,
- test with low-value flows first.
- if queue bot is enabled, verify relayer executor and bot server status in UI.

## Security philosophy
Firewall Vault reduces risk with deterministic on-chain enforcement before execution.

It does not remove all risk. Users must still secure:
- signer wallet keys,
- devices/browser,
- frontend access path,
- deployment verification assumptions.

## Canonical references
- `SECURITY_MODEL.md`
- `VERIFY_YOUR_FIREWALL.md`
