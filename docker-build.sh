#!/usr/bin/env bash
#
# docker-build.sh — build the prpl USP feed as .ipk packages in a container,
#                   using the official OpenWrt SDK image, for mt7621 / rk3308.
#
# Usage:
#   ./docker-build.sh                 # build BOTH boards
#   ./docker-build.sh mt7621          # build one board
#   ./docker-build.sh rk3308 25.12.4  # board + explicit OpenWrt version
#
# Env:
#   VERSION=24.10.7    OpenWrt release (default; overridden by 2nd arg)
#   ENABLE_MTLS=1      also build mod-ba-cli/amx-cli/tr181-security (default 1)
#   DOCKER=docker      container CLI (e.g. set to 'podman')
#
# Output: ./artifacts/<pkg-arch>/*.ipk
#
set -euo pipefail

# ---- board -> "<sdk-target-tag> <package-arch>" : single source of truth -----
board_target() {
	case "$1" in
		mt7621) echo "ramips-mt7621 mipsel_24kc" ;;
		rk3308) echo "rockchip-armv8 aarch64_generic" ;;
		*) echo "" ;;
	esac
}
ALL_BOARDS="mt7621 rk3308"

cd "$(dirname "${BASH_SOURCE[0]}")"
DOCKER="${DOCKER:-docker}"
VERSION="${2:-${VERSION:-24.10.7}}"
ENABLE_MTLS="${ENABLE_MTLS:-1}"

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
	sed -n '2,18p' "$0"; exit 0
fi

BOARDS="${1:-$ALL_BOARDS}"
command -v "${DOCKER}" >/dev/null 2>&1 || { echo "ERROR: '${DOCKER}' not found in PATH" >&2; exit 1; }

for board in ${BOARDS}; do
	read -r target arch <<<"$(board_target "${board}")"
	if [ -z "${target}" ]; then
		echo "ERROR: unknown board '${board}' (supported: ${ALL_BOARDS})" >&2
		exit 1
	fi
	img="prpl-feed-sdk:${board}-${VERSION}"
	echo "=============================================================="
	echo " board   : ${board}"
	echo " target  : openwrt/sdk:${target}-${VERSION}"
	echo " arch    : ${arch}"
	echo " image   : ${img}"
	echo "=============================================================="

	"${DOCKER}" build \
		--build-arg "TARGET=${target}" \
		--build-arg "VERSION=${VERSION}" \
		--build-arg "ENABLE_MTLS=${ENABLE_MTLS}" \
		-t "${img}" .

	# extract the staged ipks via a throwaway container
	out="artifacts/${arch}"
	mkdir -p "${out}"
	cid="$("${DOCKER}" create "${img}")"
	"${DOCKER}" cp "${cid}:/artifacts/." "${out}/"
	"${DOCKER}" rm -f "${cid}" >/dev/null

	echo "---- ${board}: $(find "${out}" -name '*.ipk' | wc -l | tr -d ' ') .ipk -> ${out}/ ----"
done

echo "=============================================================="
echo " DONE. Packages:"
find artifacts -name '*.ipk' | sort
echo "=============================================================="
