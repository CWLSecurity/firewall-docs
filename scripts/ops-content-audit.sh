#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UI_DIR="${ROOT_DIR}/../firewall-ui"
WALLET_DIR="${ROOT_DIR}/../firewall-wallet"
CONNECTOR_DIR="${ROOT_DIR}/../firewall-connector"

errors=0

log() {
  printf '[content-audit] %s\n' "$*"
}

ok() {
  printf '[content-audit][ok] %s\n' "$*"
}

fail() {
  errors=$((errors + 1))
  printf '[content-audit][fail] %s\n' "$*" >&2
}

require_match() {
  local file="$1"
  local pattern="$2"
  local label="$3"
  if rg -n -i -S "${pattern}" "${file}" >/dev/null 2>&1; then
    ok "${label}"
  else
    fail "${label} (missing pattern '${pattern}' in ${file})"
  fi
}

assert_no_match() {
  local path="$1"
  local pattern="$2"
  local label="$3"
  if rg -n -i -S "${pattern}" "${path}" >/dev/null 2>&1; then
    fail "${label} (found forbidden pattern '${pattern}' under ${path})"
    rg -n -i -S "${pattern}" "${path}" || true
  else
    ok "${label}"
  fi
}

log "checking strategy/document consistency"
require_match "${ROOT_DIR}/README.md" "MVP Scope" "PROJECT_HOME README documents MVP scope"
require_match "${ROOT_DIR}/DEPLOYMENT.md" "MVP production rollout uses .*firewall-wallet.*firewall-ui" "Deployment scope pins wallet+ui as MVP"
require_match "${ROOT_DIR}/DEPLOYMENT.md" "firewall-connector.*post-MVP" "Connector is explicitly post-MVP in deployment map"
require_match "${WALLET_DIR}/DEPLOYMENT_STATUS.md" "Base packs .*0.*1.*add-ons .*2.*3.*4" "Wallet docs include canonical pack lineup"
require_match "${UI_DIR}/README.md" "Current MVP path is fully functional without connector dependency" "UI docs keep connector out of MVP critical path"
require_match "${CONNECTOR_DIR}/README.md" "rollout is scheduled for the post-MVP phase" "Connector docs mark post-MVP rollout"

log "checking website-facing copy guardrails"
assert_no_match "${UI_DIR}/src" "guarantee(d)? (protection|safety|no losses)" "UI source avoids guarantee claims"
assert_no_match "${UI_DIR}/src" "AI( |-)?(driven|based)|AI decides transaction risk" "UI source avoids AI-risk-engine claims"
assert_no_match "${UI_DIR}/src" "universal wallet replacement|works with all dapps" "UI source avoids universal-compatibility claims"
assert_no_match "${UI_DIR}/public" "guarantee(d)? (protection|safety|no losses)" "Public assets avoid guarantee claims"

if [[ ${errors} -gt 0 ]]; then
  log "failed with ${errors} issue(s)"
  exit 1
fi

log "completed with no issues"
