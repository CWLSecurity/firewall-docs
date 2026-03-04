# Firewall Vault — Launch Checklist (MVP)

## 1) Production Deployment (UI)
- Choose hosting (Cloudflare Pages / Vercel / Netlify)
- Ensure pnpm build passes for firewall-ui
- Deploy firewall-ui/dist
- Custom domain + HTTPS (optional)
- Confirm Base-only behavior on prod URL

## 2) Trust Pack (Core + UI)
- Non-custodial statement
- On-chain enforcement (FirewallModule + PolicyRouter)
- No backend
- UI stores no keys; only localStorage for wallet addr/preset
- Link to BaseScan addresses (Factory/Router/Policies/Module)
- Link to source repos (UI + Core)
- Disclaimer: Not audited (if true)

## 3) Observability (UI)
- Add lightweight analytics (Plausible / Cloudflare Web Analytics)
- Track funnel:
  - connect
  - create wallet success
  - import wallet success
  - send success
  - execute/cancel success

## 4) Product Packaging
- Landing page copy + FAQ
- 2–3 short demo videos (create / send / queue)
- Support channel (Telegram/Discord/email)

## 5) Operational Readiness
- Verify no secrets in repo (.env, keys)
- Test Chrome/Brave + mobile MetaMask
- Known Issues list
- Incident plan
