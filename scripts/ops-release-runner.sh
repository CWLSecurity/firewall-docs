#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUN_TS="$(date -u +'%Y%m%dT%H%M%SZ')"
REPORT_DIR="${ROOT_DIR}/reports"
REPORT_PATH="${REPORT_DIR}/release-${RUN_TS}.md"
mkdir -p "${REPORT_DIR}"

RUN_PRECHECK=1
RUN_QUALITY=1
RUN_ONCHAIN=1
RUN_DEPLOY=0
RUN_LIVE_HEALTH=1

usage() {
  cat <<'USAGE'
Usage: ./scripts/ops-release-runner.sh [options]

Options:
  --skip-preflight   Skip preflight checks.
  --skip-quality     Skip quality gates.
  --skip-onchain     Skip on-chain verification.
  --deploy-ui        Run Cloudflare Pages UI deploy at the end.
  --skip-live-health Skip public site and bot live-health checks.
  --help             Show this help.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --skip-preflight) RUN_PRECHECK=0 ;;
    --skip-quality) RUN_QUALITY=0 ;;
    --skip-onchain) RUN_ONCHAIN=0 ;;
    --deploy-ui) RUN_DEPLOY=1 ;;
    --skip-live-health) RUN_LIVE_HEALTH=0 ;;
    --help)
      usage
      exit 0
      ;;
    *)
      echo "[release-runner][fail] unknown arg: $1" >&2
      usage
      exit 2
      ;;
  esac
  shift
done

status_preflight="SKIPPED"
status_quality="SKIPPED"
status_onchain="SKIPPED"
status_deploy="SKIPPED"
status_live_health="SKIPPED"

run_step() {
  local name="$1"
  shift
  echo "[release-runner] ${name}"
  "$@"
}

if [[ "${RUN_PRECHECK}" == "1" ]]; then
  run_step "preflight" "${ROOT_DIR}/scripts/ops-preflight.sh"
  status_preflight="PASS"
fi

if [[ "${RUN_QUALITY}" == "1" ]]; then
  run_step "quality gates" "${ROOT_DIR}/scripts/ops-quality-gates.sh"
  status_quality="PASS"
fi

if [[ "${RUN_ONCHAIN}" == "1" ]]; then
  if [[ -n "${BASE_RPC_URL:-}" ]]; then
    run_step "on-chain verification" "${ROOT_DIR}/scripts/ops-onchain-verify.sh"
    status_onchain="PASS"
  else
    echo "[release-runner] BASE_RPC_URL not set; skipping on-chain verification"
  fi
fi

if [[ "${RUN_DEPLOY}" == "1" ]]; then
  run_step "ui deploy" "${ROOT_DIR}/scripts/deploy-ui-cloudflare.sh"
  status_deploy="PASS"
fi

if [[ "${RUN_LIVE_HEALTH}" == "1" ]]; then
  run_step "live health checks" "${ROOT_DIR}/scripts/ops-live-health-check.sh"
  status_live_health="PASS"
fi

{
  echo "# Firewall Vault Release Report"
  echo
  echo "Generated: ${RUN_TS}"
  echo
  echo "| Step | Status |"
  echo "|---|---|"
  echo "| Preflight | ${status_preflight} |"
  echo "| Quality gates | ${status_quality} |"
  echo "| On-chain verify | ${status_onchain} |"
  echo "| UI deploy | ${status_deploy} |"
  echo "| Live health | ${status_live_health} |"
} >"${REPORT_PATH}"

echo "[release-runner] report: ${REPORT_PATH}"
