#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WALLET_DIR="${ROOT_DIR}/../firewall-wallet"
UI_DIR="${ROOT_DIR}/../firewall-ui"
CONNECTOR_DIR="${ROOT_DIR}/../firewall-connector"
RUN_ROOT="${ROOT_DIR}/.ops"
RUN_ID="$(date -u +'%Y%m%dT%H%M%SZ')"
RUN_DIR="${RUN_ROOT}/${RUN_ID}"
mkdir -p "${RUN_DIR}"

INCLUDE_CONNECTOR="${INCLUDE_CONNECTOR:-1}"

declare -A JOB_PID
declare -A JOB_LOG
declare -A JOB_STATUS

log() {
  printf '[quality] %s\n' "$*"
}

start_job() {
  local name="$1"
  local cmd="$2"
  local log_path="${RUN_DIR}/${name}.log"
  JOB_LOG["${name}"]="${log_path}"

  (
    set -euo pipefail
    printf '[job:%s] started at %s\n' "${name}" "$(date -u +'%Y-%m-%dT%H:%M:%SZ')"
    eval "${cmd}"
    printf '[job:%s] finished at %s\n' "${name}" "$(date -u +'%Y-%m-%dT%H:%M:%SZ')"
  ) >"${log_path}" 2>&1 &

  JOB_PID["${name}"]=$!
  log "started ${name} (pid ${JOB_PID[${name}]}, log ${log_path})"
}

wait_job() {
  local name="$1"
  if wait "${JOB_PID[${name}]}"; then
    JOB_STATUS["${name}"]="PASS"
  else
    JOB_STATUS["${name}"]="FAIL"
  fi
  log "${name}: ${JOB_STATUS[${name}]}"
}

log "run directory: ${RUN_DIR}"

start_job "project_home" "cd '${ROOT_DIR}' && ./scripts/integrity.sh check && ./scripts/ops-content-audit.sh"
start_job "firewall_wallet" "cd '${WALLET_DIR}' && npm run integrity:check && npm run test:contracts && npm run smoke:contracts"
start_job "firewall_ui" "cd '${UI_DIR}' && (npm install || echo '[quality][warn] npm install failed; using existing dependencies') && npm run lint && npm test && npm run smoke && npm run integrity:check"
if [[ "${INCLUDE_CONNECTOR}" == "1" ]]; then
  start_job "firewall_connector" "cd '${CONNECTOR_DIR}' && npm install && npm test && npm run typecheck && npm run build:release"
fi

wait_job "project_home"
wait_job "firewall_wallet"
wait_job "firewall_ui"
if [[ "${INCLUDE_CONNECTOR}" == "1" ]]; then
  wait_job "firewall_connector"
fi

summary="${RUN_DIR}/summary.txt"
{
  printf 'Run ID: %s\n' "${RUN_ID}"
  printf 'Generated: %s\n' "$(date -u +'%Y-%m-%dT%H:%M:%SZ')"
  printf '\n%-22s %-8s %s\n' "job" "status" "log"
  printf '%-22s %-8s %s\n' "----------------------" "--------" "--------------------------------"
  for name in "${!JOB_STATUS[@]}"; do
    printf '%-22s %-8s %s\n' "${name}" "${JOB_STATUS[${name}]}" "${JOB_LOG[${name}]}"
  done
} >"${summary}"

cat "${summary}"

failed=0
for name in "${!JOB_STATUS[@]}"; do
  if [[ "${JOB_STATUS[${name}]}" != "PASS" ]]; then
    failed=$((failed + 1))
  fi
done

if [[ ${failed} -gt 0 ]]; then
  log "failed jobs: ${failed}. inspect logs in ${RUN_DIR}"
  exit 1
fi

log "all jobs passed"
