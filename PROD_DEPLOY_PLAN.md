# Production Deploy Plan (MVP)

## UI hosting (static)
Recommended: Cloudflare Pages
Alternatives: Vercel / Netlify

## Build
- cd firewall-ui
- pnpm install
- pnpm build
Output: firewall-ui/dist

## Notes
- SPA routing behavior
- Cache headers (safe defaults)
- Base-only requirement
- Environment variables (if any)
