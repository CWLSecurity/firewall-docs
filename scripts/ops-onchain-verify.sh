#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST_PATH="${1:-${ROOT_DIR}/../firewall-wallet/packages/contracts/deployments/base-mainnet-manifest.json}"

if [[ ! -f "${MANIFEST_PATH}" ]]; then
  echo "[onchain-verify][fail] missing manifest: ${MANIFEST_PATH}" >&2
  exit 1
fi

if [[ -z "${BASE_RPC_URL:-}" ]]; then
  echo "[onchain-verify][fail] BASE_RPC_URL is required" >&2
  exit 1
fi

if ! command -v cast >/dev/null 2>&1; then
  echo "[onchain-verify][fail] cast is required" >&2
  exit 1
fi
if ! command -v jq >/dev/null 2>&1; then
  echo "[onchain-verify][fail] jq is required" >&2
  exit 1
fi

log() {
  printf '[onchain-verify] %s\n' "$*"
}

fail() {
  printf '[onchain-verify][fail] %s\n' "$*" >&2
  exit 1
}

to_dec() {
  local value
  value="$(echo "$1" | tr -d '[:space:]')"
  if [[ "${value}" == 0x* ]]; then
    cast to-dec "${value}"
  else
    echo "${value}"
  fi
}

assert_eq_dec() {
  local got="$1"
  local expected="$2"
  local label="$3"
  if [[ "${got}" != "${expected}" ]]; then
    fail "${label}: expected ${expected}, got ${got}"
  fi
  log "${label}: ${got}"
}

factory="$(jq -r '.factory' "${MANIFEST_PATH}")"
registry="$(jq -r '.policyPackRegistry' "${MANIFEST_PATH}")"
entitlement="$(jq -r '.entitlementManager' "${MANIFEST_PATH}")"
router_deployer="$(jq -r '.policyRouterDeployer' "${MANIFEST_PATH}")"

log "manifest: ${MANIFEST_PATH}"
log "factory=${factory}"
log "policyPackRegistry=${registry}"
log "entitlementManager=${entitlement}"
log "policyRouterDeployer=${router_deployer}"

for addr in "${factory}" "${registry}" "${entitlement}" "${router_deployer}"; do
  code="$(cast code "${addr}" --rpc-url "${BASE_RPC_URL}")"
  if [[ "${code}" == "0x" || -z "${code}" ]]; then
    fail "no bytecode at ${addr}"
  fi
  log "bytecode present: ${addr}"
done

expected_pack_count="$(jq -r '[.basePackConservative, .basePackDefi, .addonPackNewReceiver24h, .addonPackLargeTransfer24h] | map(select(. != null)) | length' "${MANIFEST_PATH}")"
pack_count_raw="$(cast call "${registry}" "packCount()(uint256)" --rpc-url "${BASE_RPC_URL}")"
pack_count="$(to_dec "${pack_count_raw}")"
assert_eq_dec "${pack_count}" "${expected_pack_count}" "packCount"

for ((idx = 0; idx < expected_pack_count; idx++)); do
  id_raw="$(cast call "${registry}" "packIdAt(uint256)(uint256)" "${idx}" --rpc-url "${BASE_RPC_URL}")"
  id_dec="$(to_dec "${id_raw}")"
  assert_eq_dec "${id_dec}" "${idx}" "packIdAt(${idx})"
done

for ((pack_id = 0; pack_id < expected_pack_count; pack_id++)); do
  meta="$(cast call "${registry}" "getPackMeta(uint256)(bool,uint8,uint8,bytes32,string,uint16,uint256)" "${pack_id}" --rpc-url "${BASE_RPC_URL}")"
  policies="$(cast call "${registry}" "getPackPolicies(uint256)(address[])" "${pack_id}" --rpc-url "${BASE_RPC_URL}")"
  log "pack ${pack_id} meta: ${meta}"
  log "pack ${pack_id} policies: ${policies}"
done

log "basic on-chain verification passed"
