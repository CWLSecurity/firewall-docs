#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WALLET_DIR="${ROOT_DIR}/../firewall-wallet"
UI_DIR="${ROOT_DIR}/../firewall-ui"
CONNECTOR_DIR="${ROOT_DIR}/../firewall-connector"

errors=0
warnings=0

log() {
  printf '[preflight] %s\n' "$*"
}

ok() {
  printf '[preflight][ok] %s\n' "$*"
}

warn() {
  warnings=$((warnings + 1))
  printf '[preflight][warn] %s\n' "$*" >&2
}

fail() {
  errors=$((errors + 1))
  printf '[preflight][fail] %s\n' "$*" >&2
}

check_cmd() {
  local cmd="$1"
  if command -v "$cmd" >/dev/null 2>&1; then
    ok "command '${cmd}' found"
  else
    fail "command '${cmd}' is missing"
  fi
}

check_dir() {
  local dir="$1"
  if [[ -d "${dir}" ]]; then
    ok "directory exists: ${dir}"
  else
    fail "directory is missing: ${dir}"
  fi
}

require_env() {
  local name="$1"
  if [[ -n "${!name:-}" ]]; then
    ok "env ${name} is set"
  else
    fail "env ${name} is required but missing"
  fi
}

optional_env() {
  local name="$1"
  if [[ -n "${!name:-}" ]]; then
    ok "env ${name} is set"
  else
    warn "env ${name} is not set"
  fi
}

log "checking repository layout"
check_dir "${ROOT_DIR}"
check_dir "${WALLET_DIR}"
check_dir "${UI_DIR}"
check_dir "${CONNECTOR_DIR}"

log "checking required tooling"
check_cmd node
check_cmd npm
check_cmd forge
check_cmd cast
check_cmd solc
check_cmd rg
check_cmd jq

log "printing tool versions"
node --version || true
npm --version || true
forge --version || true
cast --version || true
solc --version || true

log "checking environment"
optional_env BASE_RPC_URL
optional_env DEPLOYER_PK
optional_env RELAYER_PRIVATE_KEY
optional_env CF_PAGES_PROJECT_NAME
optional_env CLOUDFLARE_API_TOKEN
optional_env CLOUDFLARE_ACCOUNT_ID

if [[ -n "${BASE_RPC_URL:-}" ]]; then
  if cast block-number --rpc-url "${BASE_RPC_URL}" >/dev/null 2>&1; then
    ok "BASE_RPC_URL is reachable"
  else
    fail "BASE_RPC_URL is set but unreachable"
  fi
else
  warn "BASE_RPC_URL not set; on-chain verification/deploy checks will be skipped"
fi

if [[ ${errors} -gt 0 ]]; then
  log "failed with ${errors} error(s), ${warnings} warning(s)"
  exit 1
fi

log "completed successfully with ${warnings} warning(s)"
