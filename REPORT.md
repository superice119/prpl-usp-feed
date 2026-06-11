# prpl-feed — build report

## Method & provenance

All component repositories were verified to exist with `git ls-remote` / the GitLab API, and every
package's recipe was taken from the upstream **prplOS** feeds pinned at the **`prplware-v5.0.0`**
release snapshot (so the set is mutually version-compatible):

* `feed_amx`    @ `1c3641642554ddcc3e62125db46e0cb5c647a884`  (Ambiorix libs, backends, runtime, tools)
* `feed-prplos` @ `18072ac2a46521eaf2a770c30b7c322b11ca638b`  (USP layer + data-model layer, monorepo feed)

Packages are grouped into the prplOS categories `libs/` (19), `mods/` (6), `apps/` (6), `plugins/` (4);
`scripts/feeds` recurses, so the nesting does not affect `make package/<PKG_NAME>/compile`.

No URL, tag, commit, or hash in this feed was invented — versions and `PKG_HASH`/`PKG_MIRROR_HASH`
values are the upstream-published ones at those commits. Source tarballs are fetched by OpenWrt from
`<repo>/-/archive/<tag>/<name>-<tag>.tar.gz` (GitLab) or via git (`obuspa`).

> ⚠️ A lexical trap to avoid: `git ls-remote --tags | tail` sorts text, so `v4.9.9` looks "newer" than
> `v4.17.0`. The versions below are the **numerically correct, release-pinned** ones, not the lexical tail.

## Per-package table

| dir (PKG_NAME) | version | source repo (prpl-foundation/…) | key DEPENDS | feed | confirm? |
|---|---|---|---|---|---|
| libamxc | v2.7.1 | components/ambiorix/libraries/libamxc | — | feed_amx | ok |
| libamxp | v2.10.0 | components/ambiorix/libraries/libamxp | libamxc, libcap-ng | feed_amx | ok |
| libamxd | v6.11.1 | components/ambiorix/libraries/libamxd | libamxc, libamxp | feed_amx | ok |
| libamxo | v5.7.1 | components/ambiorix/libraries/libamxo | libamxc/p/d, **libamxs** | feed_amx | ok |
| libamxj | v1.2.1 | components/ambiorix/libraries/libamxj | libamxc, yajl | feed_amx | ok |
| libamxb | v4.17.0 | components/ambiorix/libraries/libamxb | libamxc/p/d, **uriparser** | feed_amx | ok |
| libamxs | v0.9.0 | components/ambiorix/libraries/libamxs | libamxc/p/d/b | feed_amx | ok |
| libamxm | v0.1.1 | components/ambiorix/libraries/libamxm | libamxc/p | feed_amx | ok |
| libamxa | v0.12.1 | components/ambiorix/libraries/libamxa | libamxc/j/d/b | feed_amx | ok |
| libsahtrace | v1.15.0 | components/ambiorix/libraries/libsahtrace | — | feed_amx | ok |
| libamxrt | v0.8.0 | components/ambiorix/libraries/libamxrt | libamxc/j/p/d/o/b, libevent2, libcap-ng | feed_amx | ok |
| uriparser | 0.9.3 | *(github.com/uriparser/uriparser)* | — (cmake) | feed_amx | ok |
| mod-amxb-ubus | v3.11.0 | components/ambiorix/modules/amxb_backends/amxb_ubus | libamxc/b/d, libubus | feed_amx | ok |
| amxrt | v2.6.1 | components/ambiorix/applications/amxrt | libamx*, libamxrt, libevent2 | feed_amx | ok |
| amxo-cg | v1.11.1 | components/ambiorix/applications/amxo-cg | libamx*, libxml2, yajl, libamxs | feed_amx | ok |
| libimtp | v2.7.0 | components/core/libraries/libimtp | — | feed-prplos | ok |
| libusp | v2.8.0 | components/core/libraries/libusp | — | feed-prplos | ok |
| libuspi | v1.4.0 | components/core/libraries/libuspi | — | feed-prplos | ok |
| libuspprotobuf | v0.5.3 | components/core/libraries/**libprotobuf** | — | feed-prplos | name≠repo |
| mod-amxb-usp | v5.10.0 | components/ambiorix/modules/amxb_backends/amxb_usp | libamx*, libimtp, libusp, libuspi | feed-prplos | ok |
| mod-usp-registration | v0.1.1 | components/core/modules/**mod-usp_registration** | libamx*, libsahtrace | feed-prplos | name≠repo |
| obuspa | v11.0.2 | *(github.com/BroadbandForum/obuspa.git @ 92ecb4c…)* + 12 prpl patches | libsqlite3, libcurl, libmosquitto, [libwebsockets4-full] | feed-prplos | ok |
| usp-discovery | v0.2.0 | components/core/plugins/usp-discovery | — | feed-prplos | optional |
| tr181-device | v0.36.0 | components/core/plugins/tr181-device | libamx*, libsahtrace, libamxm, **mod-dmext, mod-dmproxy** | feed-prplos | ok |
| deviceinfo-manager | v2.41.0 | components/core/plugins/**tr181-deviceinfo** | libamx*, libamxm, libsahtrace, mod-dmext, libfiletransfer, procps-ng | feed-prplos | name≠repo |
| tr181-gatewayinfo | v0.2.0 | components/core/plugins/tr181-gatewayinfo | libamx*, libsahtrace, **libnetmodel**, amxrt | feed-prplos | ok |
| mod-dmext | v0.15.1 | components/core/modules/mod-dmext | libamx* | feed-prplos | ok |
| mod-dmproxy | v1.6.1 | components/core/modules/mod-dmproxy | libamx* | feed-prplos | ok |
| data-model-mapper | v0.3.0 | components/core/applications/data-model-mapper | libamx* | feed-prplos | ok |
| libnetmodel | v1.5.19 | *(netmodel/libs/libnetmodel)* | libamx*, libsahtrace | feed-prplos | ok |
| libfiletransfer | v1.7.0 | components/core/libraries/libfiletransfer | libamxc/p, uriparser, libsahtrace, curl, libopenssl | feed-prplos | ok |
| libamxt | v1.0.2 | components/ambiorix/libraries/libamxt | libamxc, libamxp | feed_amx | ok |
| amx-cli | v0.6.0 | components/ambiorix/applications/amx-cli | libamxc/p/t/m/j, libevent2, yajl | feed_amx | ok |
| mod-ba-cli | v0.17.0 | components/ambiorix/modules/amx_cli/mod-ba-cli | libamx*, libamxt/m/a, amx-cli | feed_amx | ok |
| tr181-security | v0.14.0 | components/core/plugins/tr181-security | libamx*, libsahtrace, mod-dmext, libopenssl | feed-prplos | ok |

`libamx*` = the relevant subset of libamxc/p/d/o/j/b. Full `DEPENDS` are in each `Makefile`.

## Resolved questions from the original brief

* **`amxb-ubus` vs `mod-amxb-ubus`** — *same package.* prpl's name is `mod-amxb-ubus`; there is no
  separate `amxb-ubus`. One directory, `mod-amxb-ubus`.
* **`tr181-deviceinfo` merged into `tr181-device`?** — *No.* `Device.DeviceInfo.*` is a separate
  component. prpl packages it as **`deviceinfo-manager`** (its source repo is still `tr181-deviceinfo`).
  Kept as its own directory.
* **`mod-usp-registration` exists?** — *Yes*, contrary to first impressions. Repo:
  `components/core/modules/mod-usp_registration` (underscore), packaged in `feed-prplos/usp/mods`.
* **`data-model-mapper` location** — `components/core/**applications**/data-model-mapper`
  (the old `core/plugins/...` path 301-redirects to it).
* **obuspa fork** — prpl does **not** maintain a source fork; it builds **BBF upstream `obuspa`**
  (`github.com/BroadbandForum/obuspa.git`, pinned commit `92ecb4c…`, ~v11.0.2) and applies **12 patches**
  (in `obuspa/patches/`) that add the USP-Broker/USP-Service behaviour and FD passing.
* **`tr181-gatewayinfo` URL** — on `feed-prplos` `main` the recipe used a *private* SoftAtHome git URL with
  credential variables; at the `prplware-v5.0.0` snapshot it uses the **public** archive `v0.2.0`, which is
  what this feed ships. (Verified public.)

## Known risks / things to confirm before a real build

1. **Build-time closure is complete** — verified by diffing declared `DEPENDS` against shipped dirs:
   every prpl/Ambiorix dependency resolves inside the feed (35 packages, incl. `libnetmodel`/`libfiletransfer`
   closing `tr181-gatewayinfo`/`deviceinfo-manager`, and `mod-ba-cli`/`amx-cli`/`libamxt`/`tr181-security`
   closing the obuspa mTLS path). The only unbundled *build* deps are stock OpenWrt packages (see #3).
   No package will fail selection on a missing prpl dep.
2. **obuspa `ba-cli`/`tr181-security` are RUNTIME-only, not build deps.** They are *not* in obuspa's
   `DEPENDS` — obuspa compiles and installs without them. Upstream `/etc/init.d/obuspa` calls `ba-cli`
   to read `Security.CABundle`/`Security.Certificate` at boot for mTLS.
   **Handling applied here (graceful degradation):** the shipped init sets `CA_BUNDLE=""` and
   `DEVICE_KEY_CERT=""` and guards the three `get_*` helpers with `[ -z "${1}" ] && return 0`, so on a
   non-mTLS (plain `ws://`) bring-up **`ba-cli` is never invoked** — no missing-command errors and no
   5-second CA-wait loop; obuspa simply starts without the `-t <cert>` argument.
   **mTLS tooling is now bundled in this feed** (`mod-ba-cli`, `amx-cli`, `libamxt`, `tr181-security`), so
   enabling mTLS (`wss://`) is a pure config flip — no extra feeds: set `CA_BUNDLE`/`DEVICE_KEY_CERT` back
   to their `Security.*` paths, select `mod-ba-cli`+`tr181-security`, provision the cert/CA. The shipped
   init's `RESET_FILE` already points at `/etc/obuspa/factory_reset.txt` (the WebSocket/Oktopus template);
   point it back at `/etc/config/obuspa_param_reset.txt` for the upstream STOMP example.
3. **External OpenWrt feed packages** (must exist in the target buildroot): `libubus`, `libubox`,
   `libsqlite3`, `libcurl`, `curl`, `libmosquitto`, `libwebsockets4-full`, `yajl`, `libcap-ng`,
   `libevent2`, `libxml2`, `libopenssl`, `libprotobuf-c`, `procps-ng`, `procps-ng-ps`.
4. **ODL/init for tr181-***: shipped *inside the component source tarball*, installed by `make install`
   — not present in this feed's `files/`. Start-up ordering is via `rc.d` S/K symlinks generated from
   `CONFIG_SAH_*_ORDER` (`tr181-device` defaults to 41; set gateway-info higher to start it after device).
5. **Build invocations** are upstream BAF-generated and proven in prplOS CI, but were **not** re-compiled
   in this environment (no cross-toolchain here). Validate with a real `make package/<p>/compile`.
6. **`SUBMENU`/`CATEGORY`** are `prpl Foundation`; packages appear there in `menuconfig`, not under a
   generic category.
7. **Mainline-OpenWrt compatibility is unverified.** These recipes were pinned from prplOS (whose OpenWrt
   base carries SoftAtHome/prpl patches). Against **stock** OpenWrt 24.10 for `mt7621`/`rk3308`, some
   packages may need tweaks (procd/ubus assumptions, `CONFIG_SAH_*` defaults, libwebsockets variant). The
   three build methods (CI, container, SDK) exist precisely to surface this — treat the first green CI run
   as the real compatibility gate. `rk3308` board *images* are out of scope (packages are arch-only:
   `aarch64_generic`).

## Next steps in an OpenWrt buildroot

```sh
# 1. register the feed
echo 'src-link prpl_usp /path/to/prpl-feed' >> feeds.conf
./scripts/feeds update prpl_usp
./scripts/feeds install -a -p prpl_usp

# 2. (recommended) also link prplOS feed_amx + feed-prplos at prplware-v5.0.0 to cover the
#    not-bundled transitive deps (libnetmodel, tr181-security, mod-ba-cli, libfiletransfer, …)

# 3. configure
make menuconfig            # prpl Foundation -> select packages; enable OBUSPA_WEBSOCKET_MTP_SUPPORT
# or apply the diffconfig fragment from README.md

# 4. build bottom-up (OpenWrt orders by DEPENDS automatically)
make package/libamxc/compile V=s
make package/libamxb/compile V=s
make package/mod-amxb-ubus/compile V=s
make package/mod-amxb-usp/compile V=s
make package/amxrt/compile V=s
make package/obuspa/compile V=s
make package/tr181-device/compile V=s
make package/tr181-gatewayinfo/compile V=s
make package/data-model-mapper/compile V=s

# 5. on target: fill in /etc/obuspa/factory_reset.txt (Controller WebSocket Host/Port/Path + EndpointIDs),
#    point RESET_FILE in /etc/init.d/obuspa at it, then: /etc/init.d/obuspa restart
```
