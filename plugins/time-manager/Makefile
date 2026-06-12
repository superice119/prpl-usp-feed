# WARNING: Automatically generated file using BAF (Build system Agnostic File) tooling (version v2.39.3)
# WARNING: You should contribute changes to https://gitlab.com/prpl-foundation/components/core/plugins/tr181-time/-/blob/main/baf.yml instead
include $(TOPDIR)/rules.mk

PKG_NAME:=time-manager
PKG_VERSION:=v2.11.0
SHORT_DESCRIPTION:=TR181 Time plugin

PKG_SOURCE:=tr181-time-v2.11.0.tar.gz
PKG_SOURCE_URL:=https://gitlab.com/prpl-foundation/components/core/plugins/tr181-time/-/archive/v2.11.0
PKG_HASH:=631d449f970ba06906520fc87a87b60ea840144b22bc63abfe5ab735beddbd81
PKG_BUILD_DIR:=$(BUILD_DIR)/tr181-time-v2.11.0
PKG_MAINTAINER:=Soft At Home <support.opensource@softathome.com>
PKG_LICENSE:=BSD-2-Clause-Patent
PKG_LICENSE_FILES:=LICENSE

COMPONENT:=time-manager

# -r2: prpl-feed strips the requires "NetModel.Intf."/"Firewall."/"Users.User."
# from time-manager.odl — this minimal feed ships none of those providers, and the
# requires would block time-manager's startup so Device.Time never registers.
PKG_RELEASE:=2

define SAHInit/Install
	install -d $(1)/etc/rc.d/
ifneq ($(CONFIG_PACKAGE_procd),y)
	ln -sfr $(1)/etc/init.d/$(COMPONENT) $(1)/etc/rc.d/S$(CONFIG_SAH_AMX_TR181_TIME_ORDER)$(COMPONENT)
	ln -sfr $(1)/etc/init.d/$(COMPONENT) $(1)/etc/rc.d/K$(CONFIG_SAH_AMX_TR181_TIME_ORDER)$(COMPONENT)
endif
endef

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  CATEGORY:=prpl Foundation
  SUBMENU:=TR-181 Managers
  TITLE:=$(SHORT_DESCRIPTION)
  URL:=https://gitlab.com/prpl-foundation/components/core/plugins/tr181-time
  DEPENDS += +libamxc
  DEPENDS += +libamxp
  DEPENDS += +libamxd
  DEPENDS += +libamxb
  DEPENDS += +libamxo
  DEPENDS += +amxrt
  DEPENDS += +libsahtrace
  DEPENDS += +libnetmodel
  DEPENDS += +mod-dmext
  DEPENDS += +libamxm
  DEPENDS += +rpcd
  DEPENDS += +chrony-prpl
  MENU:=1
endef

define Package/$(PKG_NAME)/description
	TR181 Time plugin
endef

define Build/Compile
	$(call Build/Compile/Default, STAGINGDIR=$(STAGING_DIR) CONFIGDIR=$(STAGING_DIR) PKG_CONFIG_PATH=$(STAGING_DIR)/usr/lib/pkgconfig LIBDIR=/usr/lib INSTALL_LIB_DIR=/lib INSTALL_BIN_DIR=/bin RAW_VERSION=$(PKG_VERSION) HARDCO_HAL_DIR=$(STAGING_DIR)/usr/include PKG_CONFIG=$(PKG_CONFIG) CONFIG_SAH_AMX_TR181_TIME_ORDER=$(CONFIG_SAH_AMX_TR181_TIME_ORDER) CONFIG_PACKAGE_procd=$(CONFIG_PACKAGE_procd))
endef

define Build/Install
	$(call Build/Install/Default, install INSTALL=install D=$(PKG_INSTALL_DIR) DEST=$(PKG_INSTALL_DIR) STAGINGDIR=$(STAGING_DIR) CONFIGDIR=$(STAGING_DIR) PV=$(PKG_VERSION) PKG_CONFIG_LIBDIR=$(STAGING_DIR)/usr/lib/pkgconfig LIBDIR=/usr/lib INSTALL_LIB_DIR=/lib INSTALL_BIN_DIR=/bin RAW_VERSION=$(PKG_VERSION) HARDCO_HAL_DIR=$(STAGING_DIR)/usr/include PKG_CONFIG=$(PKG_CONFIG) CONFIG_SAH_AMX_TR181_TIME_ORDER=$(CONFIG_SAH_AMX_TR181_TIME_ORDER) CONFIG_PACKAGE_procd=$(CONFIG_PACKAGE_procd))

	$(call SAHInit/Install,$(PKG_INSTALL_DIR))
endef

define Build/InstallDev
	$(call Build/Install/Default, install INSTALL=install D=$(STAGING_DIR) DEST=$(STAGING_DIR) STAGINGDIR=$(STAGING_DIR) CONFIGDIR=$(STAGING_DIR) PV=$(PKG_VERSION) PKG_CONFIG_LIBDIR=$(STAGING_DIR)/usr/lib/pkgconfig LIBDIR=/usr/lib INSTALL_LIB_DIR=/lib INSTALL_BIN_DIR=/bin RAW_VERSION=$(PKG_VERSION) HARDCO_HAL_DIR=$(STAGING_DIR)/usr/include PKG_CONFIG=$(PKG_CONFIG) CONFIG_SAH_AMX_TR181_TIME_ORDER=$(CONFIG_SAH_AMX_TR181_TIME_ORDER) CONFIG_PACKAGE_procd=$(CONFIG_PACKAGE_procd))
	$(call SAHInit/Install,$(STAGING_DIR))
endef

define Package/$(PKG_NAME)/install
	$(CP) $(PKG_INSTALL_DIR)/* $(1)/
	if [ -d ./files ]; then \
		$(CP) ./files/* $(1)/; \
	fi
	find $(1) -name *.a -exec rm {} +;
	find $(1) -name *.h -exec rm {} +;
	find $(1) -name *.pc -exec rm {} +;
	# prpl-feed: this minimal USP feed ships no NetModel.Intf. / Firewall. / Users.User.
	# providers. time-manager.odl 'requires' all three, which makes its pre-service hook
	# block forever ("wait until object ... becomes available"), so Device.Time would
	# never register with the obuspa broker. Strip those requires so time-manager starts
	# and reports chrony's NTP sync status into Device.Time. (runs as root; no Users needed)
	sed -i -E '/^[[:space:]]*requires[[:space:]]+"(NetModel\.Intf\.|Firewall\.|Users\.User\.)";/d' \
		$(1)/etc/amx/time-manager/time-manager.odl
endef

define Package/$(PKG_NAME)/config
	source "$(SOURCE)/Config.in"
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
