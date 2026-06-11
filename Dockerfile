# Container build for the prpl USP feed using the official OpenWrt SDK.
#
# Build (per board) — see docker-build.sh for the board->TARGET/arch mapping:
#   docker build --build-arg TARGET=ramips-mt7621  --build-arg VERSION=24.10.7 -t prpl-feed-sdk:mt7621 .
#   docker build --build-arg TARGET=rockchip-armv8 --build-arg VERSION=24.10.7 -t prpl-feed-sdk:rk3308 .
#
# The compiled .ipk files are staged at /artifacts inside the image; extract with:
#   cid=$(docker create prpl-feed-sdk:mt7621); docker cp "$cid:/artifacts/." ./out/; docker rm "$cid"
#
# TARGET  = openwrt/sdk image tag prefix (ramips-mt7621 | rockchip-armv8)
# VERSION = OpenWrt release (24.10.7 default; SNAPSHOT also works)
ARG TARGET=ramips-mt7621
ARG VERSION=24.10.7
FROM openwrt/sdk:${TARGET}-${VERSION}

# 1 = also build the mTLS tooling (mod-ba-cli, amx-cli, tr181-security)
ARG ENABLE_MTLS=1

# The openwrt/sdk image runs as the unprivileged 'buildbot' user with the SDK
# at the working directory. Copy this feed in (readable by buildbot).
COPY --chown=buildbot:buildbot . /feed/

# Establish the target .config, then drive the build with the feed's own build.sh
# (IS_SDK=1 skips the source-tree "run menuconfig" path). Finally stage the ipks.
RUN set -eux; \
	[ ! -f setup.sh ] || bash setup.sh; \
	make defconfig; \
	IS_SDK=1 IGNORE_ERRORS=1 ENABLE_MTLS="${ENABLE_MTLS}" ENABLE_WEBSOCKET=1 /feed/build.sh "$PWD"; \
	mkdir -p /artifacts; \
	find bin/packages -name '*.ipk' -exec cp -v {} /artifacts/ \; ; \
	ls -l /artifacts

# Default action when the container is run: print the produced packages.
CMD ["sh", "-c", "ls -l /artifacts"]
