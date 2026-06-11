# prpl-feed — minimal prpl USP component set for OpenWrt

A self-contained OpenWrt feed that brings up the **USP (TR-369) onboarding path** on an
OpenWrt gateway so it can be managed by a USP Controller such as **Oktopus**:

```
Oktopus Controller --USP/WebSocket--> obuspa (USP Agent + Broker)
    --USP/Unix Domain Socket--> tr181-* data-model daemons (amxrt + ODL)
    --(in parallel) ubus--> local system
```

* **ubus** is the local bus on OpenWrt.
* **obuspa** is the USP Agent and acts as a **USP Broker**, aggregating the local data-model
  daemons over USP/UDS and talking to the Controller over a WebSocket MTP.
* A data-model daemon = the **`amxrt`** runtime + an **ODL** definition + the loaded **amxb**
  backend plugins (`mod-amxb-ubus` for ubus, `mod-amxb-usp` for USP).

## Version pinning (important)

Every package is pinned to the **`prplware-v5.0.0`** prplOS release snapshot so the Ambiorix
libraries, backends and data-model components are **mutually compatible** (mixing versions across
releases will not compile/link). The recipes, versions and `PKG_HASH`/`PKG_MIRROR_HASH` values in
this feed were taken verbatim from the upstream prplOS feeds at these commits:

| Upstream feed | Repo | Pinned commit (tag `prplware-v5.0.0`) |
|---|---|---|
| `feed_amx`     | `gitlab.com/prpl-foundation/prplos/feeds/feed_amx`     | `1c3641642554ddcc3e62125db46e0cb5c647a884` |
| `feed-prplos`  | `gitlab.com/prpl-foundation/prplos/feeds/feed-prplos`  | `18072ac2a46521eaf2a770c30b7c322b11ca638b` |

> Nothing here is hand-invented: the build invocations are BAF-generated upstream and the source
> tarball hashes are the upstream-published ones. If you bump a version, refresh `PKG_HASH` from the
> corresponding `/-/archive/<tag>` tarball.

## Layout

Packages are grouped into the upstream prplOS categories. OpenWrt's `scripts/feeds` recurses, so the
nesting is purely organisational — `make package/<PKG_NAME>/compile` is unaffected by the path.

```
prpl-feed/
├── libs/      Ambiorix core libs, USP protocol libs, netmodel, filetransfer, uriparser, libamxt (19)
├── mods/      bus backends + data-model/USP modules + mod-ba-cli                                  (6)
├── apps/      amxrt, amxo-cg, amx-cli, obuspa agent, usp-discovery, data-model-mapper             (6)
└── plugins/   tr181 data-model daemons (device, deviceinfo, gatewayinfo, security)                (4)
```

## What's in the feed

Sub-directory name = prpl package name (`PKG_NAME`). Keep these names — downstream `DEPENDS` reference
them. The right-hand column maps back to the component names used in the original request.

### Ambiorix core libraries (from `feed_amx`)
| dir | version | requested-as |
|---|---|---|
| `libamxc` | v2.7.1  | libamxc |
| `libamxp` | v2.10.0 | libamxp |
| `libamxd` | v6.11.1 | libamxd |
| `libamxo` | v5.7.1  | libamxo |
| `libamxj` | v1.2.1  | libamxj |
| `libamxb` | v4.17.0 | libamxb |
| `libamxs` | v0.9.0  | *(transitive: ODL sync; needed by libamxo, amxo-cg)* |
| `libamxm` | v0.1.1  | *(transitive: module mgmt; needed by tr181-device/deviceinfo)* |
| `libamxa` | v0.12.1 | *(transitive: ACL/auth)* |
| `libsahtrace` | v1.15.0 | *(transitive: tracing; needed by mod-usp-registration, tr181-*)* |
| `libamxrt`    | v0.8.0  | *(runtime library backing the `amxrt` app)* |
| `libamxt`     | v1.0.2  | *(transitive: terminal/CLI lib; needed by amx-cli / mod-ba-cli)* |
| `uriparser`   | 0.9.3   | *(transitive: hard dep of libamxb)* |

### Bus backends, runtime, tools (from `feed_amx`)
| dir | version | requested-as |
|---|---|---|
| `mod-amxb-ubus` | v3.11.0 | **amxb-ubus = mod-amxb-ubus (same package)** |
| `amxrt`         | v2.6.1  | amxrt |
| `amxo-cg`       | v1.11.1 | amxo-cg (ODL code-gen, dev tool) |
| `amx-cli`       | v0.6.0  | *(interactive bus CLI; dep of mod-ba-cli)* |
| `mod-ba-cli`    | v0.17.0 | *(provides `ba-cli` — used by obuspa init for mTLS cert lookup)* |

### USP / conversion layer (from `feed-prplos/usp`)
| dir | version | requested-as |
|---|---|---|
| `libimtp`              | v2.7.0  | *(USP IMTP transport lib — dep of mod-amxb-usp)* |
| `libusp`               | v2.8.0  | *(USP protocol lib)* |
| `libuspi`              | v1.4.0  | *(USP instance lib)* |
| `libuspprotobuf`       | v0.5.3  | *(USP protobuf lib; repo `core/libraries/libprotobuf`)* |
| `mod-amxb-usp`         | v5.10.0 | **mod-amxb-usp** (AMX↔USP backend; repo `amxb_backends/amxb_usp`) |
| `mod-usp-registration` | v0.1.1  | **mod-usp-registration** (repo `core/modules/mod-usp_registration`) |
| `obuspa`               | v11.0.2 | **obuspa** (BBF upstream + 12 prpl patches; WebSocket MTP + Broker) |
| `usp-discovery`        | v0.2.0  | *(USP discovery helper, optional)* |

### Data-model layer (from `feed-prplos/net_services`)
| dir | version | requested-as |
|---|---|---|
| `tr181-device`       | v0.36.0 | **tr181-device** (`Device.` root + framework) |
| `deviceinfo-manager` | v2.41.0 | **tr181-deviceinfo** — prpl packages `Device.DeviceInfo.*` as `deviceinfo-manager` (source repo is still `tr181-deviceinfo`) |
| `tr181-gatewayinfo`  | v0.2.0  | **tr181-gatewayinfo** (`Device.GatewayInfo.*`) |
| `mod-dmext`          | v0.15.1 | *(transitive: data-model extensions; hard dep of tr181-device)* |
| `mod-dmproxy`        | v1.6.1  | *(transitive: data-model proxy; hard dep of tr181-device)* |
| `data-model-mapper`  | v0.3.0  | **data-model-mapper** (repo `core/applications/data-model-mapper`) |
| `libnetmodel`        | v1.5.19 | *(transitive: hard dep of tr181-gatewayinfo)* |
| `libfiletransfer`    | v1.7.0  | *(transitive: hard dep of deviceinfo-manager)* |
| `tr181-security`     | v0.14.0 | *(provides `Security.*` — CA bundle/certs for obuspa mTLS)* |

> **Self-contained closure:** every `DEPENDS` declared by a package in this feed resolves either to
> another package in this feed (all prpl/Ambiorix names) or to a stock OpenWrt package
> (`libubus`, `libsqlite3`, `libcurl`, `curl`, `libmosquitto`, `libwebsockets4-full`, `yajl`,
> `libcap-ng`, `libevent2`, `libxml2`, `libopenssl`, `libprotobuf-c`, `procps-ng`, `procps-ng-ps`),
> which buildroot provides. There are **no unsatisfiable prpl-specific build dependencies**. Verify with:
> `grep -rhoE 'DEPENDS.*\+[A-Za-z0-9_.:-]+' */*/Makefile` vs `find . -name Makefile`.

## Build methods

The feed produces OpenWrt **.ipk packages** for two boards (other arches work too — just change the
target/arch):

| board | OpenWrt target | package arch | OpenWrt SDK image |
|---|---|---|---|
| **mt7621** | `ramips/mt7621` | `mipsel_24kc` | `openwrt/sdk:ramips-mt7621-24.10.7` |
| **rk3308** | `rockchip/armv8` | `aarch64_generic` | `openwrt/sdk:rockchip-armv8-24.10.7` |

Default OpenWrt release is **24.10.7** (override everywhere via a version arg/input). Four ways to build:

1. **GitHub CI** — `.github/workflows/build.yml`. On push/PR it builds the whole feed for both arches via
   the official `openwrt/gh-action-sdk`, uploads the `.ipk` as artifacts, and on a `v*` tag attaches them
   to a GitHub Release. Manual run: *Actions → Build packages → Run workflow* (optional `version` input).
2. **Container** — `./docker-build.sh [mt7621|rk3308] [version]` (no args = both boards). Builds inside
   the `openwrt/sdk` image and drops `.ipk` into `./artifacts/<arch>/`. Env: `ENABLE_MTLS=1`, `VERSION=`,
   `DOCKER=podman`.
3. **Standard OpenWrt feed** — add this feed to an existing buildroot/SDK and use `./scripts/feeds` +
   `make package/<name>/compile` (detailed below). Works with `src-link` (local) or `src-git` (remote tag).
4. **Local helper** — `./build.sh <openwrt-source-or-SDK>` automates feed register → install → `.config`
   seed → compile for any checkout you already have (knobs: `ENABLE_MTLS`, `ENABLE_WEBSOCKET`, `JOBS`,
   `WHOLE_IMAGE`). It auto-detects an SDK and skips the target-selection step.

> **WebSocket MTP is on by default** in this feed (`apps/obuspa/Config.in` sets
> `OBUSPA_WEBSOCKET_MTP_SUPPORT` to `default y` — a deliberate deviation from upstream's `n`), so all four
> methods produce a WS-capable obuspa that pulls `libwebsockets4-full`. Set it to `n` for STOMP/UDS-only.

## Using this feed in an OpenWrt / prplOS buildroot

### Quick start (scripted)

```sh
# 1. point feeds.conf at the standard OpenWrt feeds + this one
cp feeds.conf.example <openwrt-source>/feeds.conf      # then edit branch + path
# 2. choose your board/arch once
cd <openwrt-source> && make menuconfig                 # set Target System / Profile, save
# 3. register feed, install packages, seed .config, build — all in one go
/path/to/prpl-feed/build.sh <openwrt-source>
#    knobs: ENABLE_MTLS=1 (build mod-ba-cli/amx-cli/tr181-security),
#           ENABLE_WEBSOCKET=0, WHOLE_IMAGE=1, JOBS=8
```

`feeds.conf.example` and `build.sh` live at this feed's root. The script is idempotent. The manual
equivalent is below.

### Manual steps

Add the feed to `feeds.conf` (or `feeds.conf.default`) — local path or remote git tag:

```
# local checkout (absolute path):
src-link prpl_usp /path/to/prpl-feed
# or a pinned remote tag:
src-git prpl_usp https://<host>/<you>/prpl-feed.git;v0.1.0
```

Then:

```sh
./scripts/feeds update prpl_usp
./scripts/feeds install -a -p prpl_usp
```

Select the packages in `make menuconfig` under **prpl Foundation**, enable WebSocket MTP, and build:

```sh
make package/libamxc/compile V=s        # build bottom-up; OpenWrt resolves DEPENDS order
make package/obuspa/compile V=s
make package/tr181-device/compile V=s
```

### Recommended `diffconfig` fragment

```text
# --- Ambiorix core ---
CONFIG_PACKAGE_libamxc=y
CONFIG_PACKAGE_libamxp=y
CONFIG_PACKAGE_libamxd=y
CONFIG_PACKAGE_libamxo=y
CONFIG_PACKAGE_libamxj=y
CONFIG_PACKAGE_libamxb=y
CONFIG_PACKAGE_libamxs=y
CONFIG_PACKAGE_libamxm=y
CONFIG_PACKAGE_libsahtrace=y
CONFIG_PACKAGE_libamxrt=y
CONFIG_PACKAGE_uriparser=y
# --- backends + runtime ---
CONFIG_PACKAGE_mod-amxb-ubus=y
CONFIG_PACKAGE_mod-amxb-usp=y
CONFIG_PACKAGE_amxrt=y
# --- USP agent/broker ---
CONFIG_PACKAGE_obuspa=y
CONFIG_OBUSPA_WEBSOCKET_MTP_SUPPORT=y      # enables WebSocket MTP -> pulls libwebsockets4-full
CONFIG_PACKAGE_mod-usp-registration=y
CONFIG_PACKAGE_data-model-mapper=m
# --- mTLS tooling for obuspa (optional; install if you switch to wss://) ---
CONFIG_PACKAGE_mod-ba-cli=y
CONFIG_PACKAGE_amx-cli=y
CONFIG_PACKAGE_tr181-security=y
# --- data model ---
CONFIG_PACKAGE_tr181-device=y
CONFIG_PACKAGE_mod-dmext=y
CONFIG_PACKAGE_mod-dmproxy=y
CONFIG_PACKAGE_deviceinfo-manager=y
CONFIG_PACKAGE_libfiletransfer=y
CONFIG_PACKAGE_tr181-gatewayinfo=y
CONFIG_PACKAGE_libnetmodel=y
# Start-up ordering (tr181-device before gatewayinfo); defaults shown, tune as needed
CONFIG_SAH_AMX_TR181_DEVICE_ORDER=41
```

## obuspa specifics

* **WebSocket MTP** is controlled by `CONFIG_OBUSPA_WEBSOCKET_MTP_SUPPORT` (see `apps/obuspa/Config.in`),
  which this feed sets to **`default y`** (upstream default is `n`). When enabled the Makefile drops
  `--disable-websockets` and adds a dependency on `libwebsockets4-full`. obuspa is also built with
  `--disable-bulkdata --disable-coap`.
* **Broker / ubus**: the prpl patch set (`obuspa/patches/00x..01x`) turns obuspa into a USP Broker that
  registers the data-model daemons (USP Services) and connects the broker to the controller once the
  critical services have registered. The local data models reach obuspa over USP/UDS; they reach the
  system over ubus via `mod-amxb-ubus`.
* **Factory-reset config**:
  * `files/etc/obuspa/factory_reset.txt` — a **WebSocket-MTP** template for Oktopus with
    `Device.LocalAgent.EndpointID` and the Controller WebSocket **Host/Port/Path** placeholders to fill in.
    **This is what `RESET_FILE` in the shipped `/etc/init.d/obuspa` points to by default.**
  * `files/etc/config/obuspa_param_reset.txt` — the upstream **STOMP** example (kept for reference; point
    `RESET_FILE` back at it to use STOMP instead).
* **Runtime dependency on `ba-cli`**: the shipped `/etc/init.d/obuspa` queries the `Security.*` data
  model through **`ba-cli`** (from `mod-ba-cli`, in `feed_amx`) and expects **`tr181-security`** to provide
  the CA bundle / certificate for mTLS. For a plain (non-mTLS) WebSocket bring-up you can either install
  `mod-ba-cli` + `tr181-security`, or simplify the init script to drop the `get_*` helpers and the `-t`
  certificate argument. This is the main "handle the dependency" item to be aware of.

## tr181-* data-model daemons

* The **ODL** files and the **procd init scripts** for `tr181-device`, `deviceinfo-manager` and
  `tr181-gatewayinfo` are **installed from each component's own source tarball** by its `make install`
  (`Build/Install`), not shipped inside this feed. Start-up ordering is handled by the `rc.d`
  S/K symlinks created in each package's `SAHInit/Install`, driven by the `CONFIG_SAH_*_ORDER`
  values in the per-package `Config.in` (e.g. `tr181-device` defaults to order 41 — set the gateway-info
  order higher so `tr181-device` starts first).

## Dependencies NOT bundled in this feed

**Build-time:** none that are prpl-specific. All prpl/Ambiorix `DEPENDS` are satisfied inside this feed
(31 packages). The only unbundled build deps are **stock OpenWrt packages** provided by buildroot:
`libubus`, `libubox`, `libsqlite3`, `libcurl`, `curl`, `libmosquitto`, `libwebsockets4-full`, `yajl`,
`libcap-ng`, `libevent2`, `libxml2`, `libopenssl`, `libprotobuf-c`, `procps-ng`, `procps-ng-ps`.

**obuspa mTLS tooling is now bundled.** `mod-ba-cli`(+`amx-cli`,`libamxt`) and `tr181-security` are part
of this feed, so the `ba-cli` tool and the `Security.*` data model are available on the target. They are
**runtime-only** — *not* in obuspa's `DEPENDS` — so obuspa still compiles/installs independently of them.

**Default behaviour (graceful degradation / `ws://`):** the shipped `files/etc/init.d/obuspa` sets
`CA_BUNDLE=""` / `DEVICE_KEY_CERT=""` and guards the `get_*` helpers, so on a plain `ws://` bring-up
**`ba-cli` is never called** even though it is installed — no errors, no 5-second wait; obuspa starts
without `-t`. **Enabling mTLS (`wss://`) is now a pure config flip** (no extra feeds needed): set
`CA_BUNDLE`/`DEVICE_KEY_CERT` in the init script back to their `Security.*` data-model paths, provision the
cert/CA via `tr181-security`, and select `mod-ba-cli` + `tr181-security` in the build.

See `REPORT.md` for the full per-package source/version/dependency table and the known-risk list.
