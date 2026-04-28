#!/usr/bin/env bash
set -euo pipefail

SITE_URL_PRIMARY="${SITE_URL_PRIMARY:-https://firewall-wallet.com}"
SITE_URL_SECONDARY="${SITE_URL_SECONDARY:-https://www.firewall-wallet.com}"
BOT_HEALTH_URL="${BOT_HEALTH_URL:-https://bot.firewall-wallet.com/api/v1/bot/health}"

MAX_RETRIES="${MAX_RETRIES:-3}"
RETRY_DELAY_SECONDS="${RETRY_DELAY_SECONDS:-2}"
CURL_TIMEOUT_SECONDS="${CURL_TIMEOUT_SECONDS:-20}"
REQUIRE_SECURE_BOT_AUTH="${REQUIRE_SECURE_BOT_AUTH:-1}"
EXPECTED_BOT_AUTH_MODE="${EXPECTED_BOT_AUTH_MODE:-token}"

log() {
  printf '[live-health] %s\n' "$*"
}

fail() {
  printf '[live-health][fail] %s\n' "$*" >&2
  exit 1
}

require_cmd() {
  local cmd="$1"
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    fail "required command missing: ${cmd}"
  fi
}

check_site() {
  local label="$1"
  local url="$2"
  local attempt status

  for ((attempt = 1; attempt <= MAX_RETRIES; attempt++)); do
    status="$(curl -sS -L --max-time "${CURL_TIMEOUT_SECONDS}" -o /dev/null -w '%{http_code}' "${url}" || true)"
    if [[ "${status}" =~ ^2[0-9][0-9]$ || "${status}" =~ ^3[0-9][0-9]$ ]]; then
      log "[ok] ${label}: ${url} -> HTTP ${status}"
      return 0
    fi
    log "[retry ${attempt}/${MAX_RETRIES}] ${label}: ${url} -> HTTP ${status:-curl-error}"
    sleep "${RETRY_DELAY_SECONDS}"
  done

  fail "${label} is not reachable with healthy HTTP status: ${url}"
}

check_bot_health() {
  local response ok has_rpc has_relayer auth_mode
  response="$(curl -sS -L --max-time "${CURL_TIMEOUT_SECONDS}" "${BOT_HEALTH_URL}")"

  ok="$(printf '%s' "${response}" | jq -r '.ok // empty')"
  has_rpc="$(printf '%s' "${response}" | jq -r '.runtime.hasBaseRpc // empty')"
  has_relayer="$(printf '%s' "${response}" | jq -r '.runtime.hasRelayerKey // empty')"
  auth_mode="$(printf '%s' "${response}" | jq -r '.security.mutationAuthMode // empty')"

  [[ "${ok}" == "true" ]] || fail "bot health failed: .ok != true"
  [[ "${has_rpc}" == "true" ]] || fail "bot health failed: .runtime.hasBaseRpc != true"
  [[ "${has_relayer}" == "true" ]] || fail "bot health failed: .runtime.hasRelayerKey != true"

  if [[ "${REQUIRE_SECURE_BOT_AUTH}" == "1" ]]; then
    [[ -n "${auth_mode}" ]] || fail "bot health failed: .security.mutationAuthMode is missing"
    [[ "${auth_mode}" != "unsafe-remote" ]] || fail "bot health failed: .security.mutationAuthMode is unsafe-remote"
    if [[ -n "${EXPECTED_BOT_AUTH_MODE}" && "${auth_mode}" != "${EXPECTED_BOT_AUTH_MODE}" ]]; then
      fail "bot health failed: .security.mutationAuthMode expected ${EXPECTED_BOT_AUTH_MODE}, got ${auth_mode}"
    fi
  fi

  log "[ok] bot health: ${BOT_HEALTH_URL}"
  log "[ok] bot auth mode: ${auth_mode:-unknown}"
}

require_cmd curl
require_cmd jq

log "checking live site availability"
check_site "site-primary" "${SITE_URL_PRIMARY}"
check_site "site-secondary" "${SITE_URL_SECONDARY}"

log "checking bot health endpoint"
check_bot_health

log "all live health checks passed"
