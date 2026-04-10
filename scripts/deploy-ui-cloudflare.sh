#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UI_DIR="${ROOT_DIR}/../firewall-ui"

require_env() {
  local name="$1"
  if [[ -z "${!name:-}" ]]; then
    echo "[ui-deploy][fail] missing required env: ${name}" >&2
    exit 1
  fi
}

echo "[ui-deploy] preparing firewall-ui build"
cd "${UI_DIR}"
(npm install || echo "[ui-deploy][warn] npm install failed; using existing dependencies")
npm run build

require_env CLOUDFLARE_API_TOKEN
require_env CLOUDFLARE_ACCOUNT_ID
require_env CF_PAGES_PROJECT_NAME

CF_PAGES_BRANCH="${CF_PAGES_BRANCH:-main}"
CF_PAGES_COMMIT_HASH="${CF_PAGES_COMMIT_HASH:-local-$(date -u +'%Y%m%d%H%M%S')}"
CF_PAGES_COMMIT_MESSAGE="${CF_PAGES_COMMIT_MESSAGE:-MVP release deploy}"
CF_PAGES_COMMIT_DIRTY="${CF_PAGES_COMMIT_DIRTY:-true}"

echo "[ui-deploy] deploying dist/ to Cloudflare Pages project ${CF_PAGES_PROJECT_NAME} (branch ${CF_PAGES_BRANCH})"
npx wrangler pages deploy dist \
  --project-name "${CF_PAGES_PROJECT_NAME}" \
  --branch "${CF_PAGES_BRANCH}" \
  --commit-hash "${CF_PAGES_COMMIT_HASH}" \
  --commit-message "${CF_PAGES_COMMIT_MESSAGE}" \
  --commit-dirty "${CF_PAGES_COMMIT_DIRTY}"

echo "[ui-deploy] deploy command completed"
