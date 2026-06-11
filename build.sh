#!/usr/bin/env bash
#
# build.sh — register this feed in an OpenWrt buildroot, install the packages,
#            seed the .config, and compile the prpl USP component set.
#
# Usage:
#   ./build.sh <path-to-openwrt-source>
#   OPENWRT_DIR=/path/to/openwrt ./build.sh
#
# Optional environment knobs:
#   ENABLE_WEBSOCKET=1   build obuspa with WebSocket MTP (default 1)
#   ENABLE_MTLS=0        also build/select the mTLS tooling
#                        (mod-ba-cli, amx-cli, tr181-security)        (default 0)
#   FEED_NAME=prpl_usp   feed name used in feeds.conf                 (default prpl_usp)
#   JOBS=<n>             parallel build jobs                          (default: nproc)
#   WHOLE_IMAGE=0        1 = `make` a full image instead of per-package compile
#
# This script is idempotent: re-running it re-syncs the feed and rebuilds.
#
set -euo pipefail

# --- locate this feed (absolute path of the dir containing this script) ------
FEED_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FEED_NAME="${FEED_NAME:-prpl_usp}"

# --- locate the OpenWrt buildroot --------------------------------------------
OPENWRT_DIR="${1:-${OPENWRT_DIR:-}}"
if [ -z "${OPENWRT_DIR}" ]; then
	echo "ERROR: OpenWrt source dir not given." >&2
	echo "Usage: $0 <path-to-openwrt-source>   (or set OPENWRT_DIR=)" >&2
	exit 1
fi
OPENWRT_DIR="$(cd "${OPENWRT_DIR}" && pwd)"
if [ ! -x "${OPENWRT_DIR}/scripts/feeds" ]; then
	echo "ERROR: ${OPENWRT_DIR} does not look like an OpenWrt source tree" >&2
	echo "       (scripts/feeds not found). Clone/extract OpenWrt first." >&2
	exit 1
fi

ENABLE_WEBSOCKET="${ENABLE_WEBSOCKET:-1}"
ENABLE_MTLS="${ENABLE_MTLS:-0}"
WHOLE_IMAGE="${WHOLE_IMAGE:-0}"
JOBS="${JOBS:-$( (nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4) )}"

# --- packages to select (top-level; libraries are pulled in via DEPENDS) -----
PKGS=(
	obuspa
	amxrt
	amxo-cg
	mod-amxb-ubus
	mod-amxb-usp
	mod-usp-registration
	usp-discovery
	data-model-mapper
	tr181-device
	deviceinfo-manager
	tr181-gatewayinfo
)
if [ "${ENABLE_MTLS}" = "1" ]; then
	PKGS+=( mod-ba-cli amx-cli tr181-security )
fi

echo "=============================================================="
echo " feed dir   : ${FEED_DIR}"
echo " openwrt    : ${OPENWRT_DIR}"
echo " feed name  : ${FEED_NAME}"
echo " websocket  : ${ENABLE_WEBSOCKET}   mTLS tooling: ${ENABLE_MTLS}"
echo " jobs       : ${JOBS}"
echo " packages   : ${PKGS[*]}"
echo "=============================================================="

cd "${OPENWRT_DIR}"

# --- 1. register the feed (idempotent) ---------------------------------------
[ -f feeds.conf ] || { [ -f feeds.conf.default ] && cp feeds.conf.default feeds.conf || : ; }
touch feeds.conf
SRC_LINE="src-link ${FEED_NAME} ${FEED_DIR}"
if grep -qE "^src-link[[:space:]]+${FEED_NAME}[[:space:]]" feeds.conf; then
	# replace any existing definition so the path is always correct
	tmp="$(mktemp)"
	grep -vE "^src-link[[:space:]]+${FEED_NAME}[[:space:]]" feeds.conf > "${tmp}"
	mv "${tmp}" feeds.conf
fi
echo "${SRC_LINE}" >> feeds.conf
echo "[1/4] feeds.conf -> ${SRC_LINE}"

# --- 2. update + install feeds -----------------------------------------------
echo "[2/4] updating feeds..."
./scripts/feeds update -a
echo "      installing prpl_usp packages (+ their cross-feed deps)..."
./scripts/feeds install -p "${FEED_NAME}" -a
# also pull each selected package by name (forces dependency resolution)
for p in "${PKGS[@]}"; do
	./scripts/feeds install "${p}"
done

# --- 3. seed .config ---------------------------------------------------------
# An OpenWrt *SDK* ships a ready .config with the target (board/arch) already
# fixed; a full *source* tree does not, and the user must pick a target first.
# IS_SDK may be forced via env (the container path sets IS_SDK=1); otherwise auto-detect.
IS_SDK="${IS_SDK:-0}"
if [ "${IS_SDK}" != "1" ] && [ -f .config ] && grep -q '^CONFIG_TARGET_BOARD=' .config; then
	IS_SDK=1
fi
if [ "${IS_SDK}" = "1" ]; then
	echo "      detected a preconfigured tree/SDK (target already set) — skipping menuconfig."
elif [ ! -f .config ]; then
	echo "WARNING: no .config and no preset target — generating a bare one with 'make defconfig'." >&2
	echo "         On a full SOURCE tree, run 'make menuconfig' first to choose TARGET (board/arch)." >&2
	echo "         (OpenWrt SDKs ship a preset .config, so this branch should not hit in an SDK.)" >&2
	make defconfig
fi
echo "[3/4] selecting packages in .config..."
{
	for p in "${PKGS[@]}"; do
		echo "CONFIG_PACKAGE_${p}=y"
	done
	if [ "${ENABLE_WEBSOCKET}" = "1" ]; then
		echo "CONFIG_OBUSPA_WEBSOCKET_MTP_SUPPORT=y"
	fi
} >> .config
make defconfig

# --- 4. build ----------------------------------------------------------------
echo "[4/4] building..."
if [ "${WHOLE_IMAGE}" = "1" ]; then
	make -j"${JOBS}"
else
	# Build the libraries first (download+compile), then each selected package.
	# OpenWrt resolves DEPENDS order automatically; on failure, re-run verbose.
	for p in "${PKGS[@]}"; do
		echo "----- package/${p}/compile -----"
		if ! make -j"${JOBS}" "package/${p}/compile"; then
			echo "!! ${p} failed — re-running verbose for diagnostics" >&2
			make -j1 V=s "package/${p}/compile"
		fi
	done
	echo "indexing package repository..."
	make -j"${JOBS}" package/index
fi

echo "=============================================================="
echo " DONE. Resulting .ipk files:"
find "${OPENWRT_DIR}/bin" -name '*.ipk' 2>/dev/null | grep -E \
	'obuspa|amx|tr181|usp|dmext|dmproxy|netmodel|sahtrace|uriparser|filetransfer|ba-cli|security' \
	|| echo "   (none found under bin/ — check the build log above)"
echo "=============================================================="
