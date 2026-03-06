# Firewall Vault — Security Policy

## Reporting a vulnerability

If you believe you have found a security vulnerability in Firewall Vault, please report it responsibly.

Please **do not disclose vulnerabilities publicly** before they have been reviewed.

Send vulnerability reports to:

security@firewallvault.io

Include as much information as possible:

- description of the vulnerability
- steps to reproduce
- affected contracts or components
- potential impact
- suggested mitigation if known

## Responsible disclosure

We ask security researchers to:

- avoid exploiting vulnerabilities beyond what is necessary to demonstrate the issue
- avoid accessing or modifying user funds
- give the project time to investigate and fix the issue before public disclosure

## Scope

This policy applies to:

- Firewall Vault smart contracts
- Firewall Vault UI
- official documentation repositories

Repositories:

- firewall-wallet
- firewall-ui
- PROJECT_HOME

## Out of scope

The following are generally considered out of scope:

- attacks that require compromised user devices
- attacks that require stolen private keys
- attacks that depend on compromised browser extensions
- attacks involving third-party services outside the Firewall Vault codebase

## Current project status

Firewall Vault is currently in **MVP stage**.

Important notes:

- contracts may not yet be audited
- security assumptions are documented in the project documentation
- users should treat the system as experimental software

## Security philosophy

Firewall Vault is designed to reduce transaction risk through **on-chain enforcement** rather than off-chain warnings.

However, it does not eliminate all risks.

Users must still:

- secure their wallets
- secure their devices
- verify contract deployments
- understand current MVP limitations

## Acknowledgements

We appreciate responsible security research and will acknowledge researchers who help improve the safety of the project.
