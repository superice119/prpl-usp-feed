# WARNING: Automatically generated file using BAF (Build system Agnostic File) tooling (version v2.39.3)
# WARNING: You should contribute changes to https://gitlab.com/prpl-foundation/components/core/plugins/tr181-deviceinfo/-/blob/main/baf.yml instead
include $(TOPDIR)/rules.mk

PKG_NAME:=deviceinfo-manager
PKG_VERSION:=v2.41.0
SHORT_DESCRIPTION:=TR-181 compatible DeviceInfo plugin

PKG_SOURCE:=tr181-deviceinfo-v2.41.0.tar.gz
PKG_SOURCE_URL:=https://gitlab.com/prpl-foundation/components/core/plugins/tr181-deviceinfo/-/archive/v2.41.0
PKG_HASH:=5f37aa6b486db5daf4091bb940167bf0ad1dd60c2000b2c429b117e7c295abfb
PKG_BUILD_DIR:=$(BUILD_DIR)/tr181-deviceinfo-v2.41.0
PKG_MAINTAINER:=Soft At Home <support.opensource@softathome.com>
PKG_LICENSE:=BSD-2-Clause-Patent
PKG_LICENSE_FILES:=LICENSE

COMPONENT:=deviceinfo-manager

# -r2: prpl-feed drops the requires "Users.User." extension (no Device.Users
# provider in this minimal feed) so DeviceInfo registers without a Users daemon.
PKG_RELEASE:=2

define SAHInit/Install
	install -d $(1)/etc/rc.d/
	ln -sfr $(1)/etc/init.d/deviceinfo-environment $(1)/etc/rc.d/S$(CONFIG_SAH_AMX_TR181_ENVIRONMENT_ORDER)deviceinfo-environment
	ln -sfr $(1)/etc/init.d/deviceinfo-environment $(1)/etc/rc.d/K$(CONFIG_SAH_AMX_TR181_ENVIRONMENT_ORDER)deviceinfo-environment
ifneq ($(CONFIG_PACKAGE_procd),y)
	ln -sfr $(1)/etc/init.d/$(COMPONENT) $(1)/etc/rc.d/S$(CONFIG_SAH_AMX_TR181_DEVICEINFO_ORDER)$(COMPONENT)
	ln -sfr $(1)/etc/init.d/$(COMPONENT) $(1)/etc/rc.d/K$(CONFIG_SAH_AMX_TR181_DEVICEINFO_ORDER)$(COMPONENT)
endif
ifneq ($(CONFIG_PACKAGE_procd),y)
	ln -sfr $(1)/etc/init.d/deviceinfo-system $(1)/etc/rc.d/S$(CONFIG_SAH_AMX_TR181_DEVICEINFO_SYSTEM_ORDER)deviceinfo-system
	ln -sfr $(1)/etc/init.d/deviceinfo-system $(1)/etc/rc.d/K$(CONFIG_SAH_AMX_TR181_DEVICEINFO_SYSTEM_ORDER)deviceinfo-system
endif
	ln -sfr $(1)/etc/init.d/z_sysinit_done $(1)/etc/rc.d/S99z_sysinit_done
	ln -sfr $(1)/etc/init.d/z_sysinit_done $(1)/etc/rc.d/K99z_sysinit_done
	ln -sfr $(1)/etc/init.d/w_dbready $(1)/etc/rc.d/S99w_dbready
	ln -sfr $(1)/etc/init.d/w_dbready $(1)/etc/rc.d/K99w_dbready
endef

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  CATEGORY:=prpl Foundation
  SUBMENU:=TR-181 Managers
  TITLE:=$(SHORT_DESCRIPTION)
  URL:=https://gitlab.com/prpl-foundation/components/core/plugins/tr181-deviceinfo
  DEPENDS += +libamxc
  DEPENDS += +libamxj
  DEPENDS += +libamxp
  DEPENDS += +libamxd
  DEPENDS += +libamxb
  DEPENDS += +libamxo
  DEPENDS += +libamxm
  DEPENDS += +libsahtrace
  DEPENDS += +mod-dmext
  DEPENDS += +procps-ng
  DEPENDS += +procps-ng-ps
  DEPENDS += +libfiletransfer
  MENU:=1
endef

define Package/$(PKG_NAME)/description
	TR-181 compatible DeviceInfo plugin
endef

define Build/Compile
	$(call Build/Compile/Default, STAGINGDIR=$(STAGING_DIR) CONFIGDIR=$(STAGING_DIR) PKG_CONFIG_PATH=$(STAGING_DIR)/usr/lib/pkgconfig LIBDIR=/usr/lib INSTALL_LIB_DIR=/lib INSTALL_BIN_DIR=/bin RAW_VERSION=$(PKG_VERSION) HARDCO_HAL_DIR=$(STAGING_DIR)/usr/include PKG_CONFIG=$(PKG_CONFIG) CONFIG_SAH_AMX_TR181_DEVICEINFO_ORDER=$(CONFIG_SAH_AMX_TR181_DEVICEINFO_ORDER) CONFIG_SAH_AMX_TR181_DEVICEINFO_SYSTEM_ORDER=$(CONFIG_SAH_AMX_TR181_DEVICEINFO_SYSTEM_ORDER) CONFIG_SAH_AMX_TR181_ENVIRONMENT_ORDER=$(CONFIG_SAH_AMX_TR181_ENVIRONMENT_ORDER) CONFIG_SAH_AMX_ADD_SYSINIT_DONE_SCRIPT=$(CONFIG_SAH_AMX_ADD_SYSINIT_DONE_SCRIPT) CONFIG_SAH_AMX_ADD_DBREADY_SCRIPT=$(CONFIG_SAH_AMX_ADD_DBREADY_SCRIPT) CONFIG_SAH_AMX_TR181_DEVICEINFO_DEVELOPMENT=$(CONFIG_SAH_AMX_TR181_DEVICEINFO_DEVELOPMENT) CONFIG_SAH_AMX_TR181_DEVICEINFO_SOFTWARE_VERSION=$(CONFIG_SAH_AMX_TR181_DEVICEINFO_SOFTWARE_VERSION) CONFIG_SAH_AMX_TR181_DEVICEINFO_RUN_AS_USER=$(CONFIG_SAH_AMX_TR181_DEVICEINFO_RUN_AS_USER) CONFIG_SAH_AMX_TR181_DEVICEINFO_RUN_AS_GROUP=$(CONFIG_SAH_AMX_TR181_DEVICEINFO_RUN_AS_GROUP) CONFIG_SAH_AMX_TR181_DEVICEINFO_NUMBER_OF_EXTRA_MAC_ADDRESSES=$(CONFIG_SAH_AMX_TR181_DEVICEINFO_NUMBER_OF_EXTRA_MAC_ADDRESSES) CONFIG_SAH_AMX_TR181_DEVICEINFO_REQUIRES_USERS=$(CONFIG_SAH_AMX_TR181_DEVICEINFO_REQUIRES_USERS) CONFIG_PACKAGE_procd=$(CONFIG_PACKAGE_procd))
endef

define Build/Install
	$(call Build/Install/Default, install INSTALL=install D=$(PKG_INSTALL_DIR) DEST=$(PKG_INSTALL_DIR) STAGINGDIR=$(STAGING_DIR) CONFIGDIR=$(STAGING_DIR) PV=$(PKG_VERSION) PKG_CONFIG_LIBDIR=$(STAGING_DIR)/usr/lib/pkgconfig LIBDIR=/usr/lib INSTALL_LIB_DIR=/lib INSTALL_BIN_DIR=/bin RAW_VERSION=$(PKG_VERSION) HARDCO_HAL_DIR=$(STAGING_DIR)/usr/include PKG_CONFIG=$(PKG_CONFIG) CONFIG_SAH_AMX_TR181_DEVICEINFO_ORDER=$(CONFIG_SAH_AMX_TR181_DEVICEINFO_ORDER) CONFIG_SAH_AMX_TR181_DEVICEINFO_SYSTEM_ORDER=$(CONFIG_SAH_AMX_TR181_DEVICEINFO_SYSTEM_ORDER) CONFIG_SAH_AMX_TR181_ENVIRONMENT_ORDER=$(CONFIG_SAH_AMX_TR181_ENVIRONMENT_ORDER) CONFIG_SAH_AMX_ADD_SYSINIT_DONE_SCRIPT=$(CONFIG_SAH_AMX_ADD_SYSINIT_DONE_SCRIPT) CONFIG_SAH_AMX_ADD_DBREADY_SCRIPT=$(CONFIG_SAH_AMX_ADD_DBREADY_SCRIPT) CONFIG_SAH_AMX_TR181_DEVICEINFO_DEVELOPMENT=$(CONFIG_SAH_AMX_TR181_DEVICEINFO_DEVELOPMENT) CONFIG_SAH_AMX_TR181_DEVICEINFO_SOFTWARE_VERSION=$(CONFIG_SAH_AMX_TR181_DEVICEINFO_SOFTWARE_VERSION) CONFIG_SAH_AMX_TR181_DEVICEINFO_RUN_AS_USER=$(CONFIG_SAH_AMX_TR181_DEVICEINFO_RUN_AS_USER) CONFIG_SAH_AMX_TR181_DEVICEINFO_RUN_AS_GROUP=$(CONFIG_SAH_AMX_TR181_DEVICEINFO_RUN_AS_GROUP) CONFIG_SAH_AMX_TR181_DEVICEINFO_NUMBER_OF_EXTRA_MAC_ADDRESSES=$(CONFIG_SAH_AMX_TR181_DEVICEINFO_NUMBER_OF_EXTRA_MAC_ADDRESSES) CONFIG_SAH_AMX_TR181_DEVICEINFO_REQUIRES_USERS=$(CONFIG_SAH_AMX_TR181_DEVICEINFO_REQUIRES_USERS) CONFIG_PACKAGE_procd=$(CONFIG_PACKAGE_procd))

	$(call SAHInit/Install,$(PKG_INSTALL_DIR))
endef

define Build/InstallDev
	$(call Build/Install/Default, install INSTALL=install D=$(STAGING_DIR) DEST=$(STAGING_DIR) STAGINGDIR=$(STAGING_DIR) CONFIGDIR=$(STAGING_DIR) PV=$(PKG_VERSION) PKG_CONFIG_LIBDIR=$(STAGING_DIR)/usr/lib/pkgconfig LIBDIR=/usr/lib INSTALL_LIB_DIR=/lib INSTALL_BIN_DIR=/bin RAW_VERSION=$(PKG_VERSION) HARDCO_HAL_DIR=$(STAGING_DIR)/usr/include PKG_CONFIG=$(PKG_CONFIG) CONFIG_SAH_AMX_TR181_DEVICEINFO_ORDER=$(CONFIG_SAH_AMX_TR181_DEVICEINFO_ORDER) CONFIG_SAH_AMX_TR181_DEVICEINFO_SYSTEM_ORDER=$(CONFIG_SAH_AMX_TR181_DEVICEINFO_SYSTEM_ORDER) CONFIG_SAH_AMX_TR181_ENVIRONMENT_ORDER=$(CONFIG_SAH_AMX_TR181_ENVIRONMENT_ORDER) CONFIG_SAH_AMX_ADD_SYSINIT_DONE_SCRIPT=$(CONFIG_SAH_AMX_ADD_SYSINIT_DONE_SCRIPT) CONFIG_SAH_AMX_ADD_DBREADY_SCRIPT=$(CONFIG_SAH_AMX_ADD_DBREADY_SCRIPT) CONFIG_SAH_AMX_TR181_DEVICEINFO_DEVELOPMENT=$(CONFIG_SAH_AMX_TR181_DEVICEINFO_DEVELOPMENT) CONFIG_SAH_AMX_TR181_DEVICEINFO_SOFTWARE_VERSION=$(CONFIG_SAH_AMX_TR181_DEVICEINFO_SOFTWARE_VERSION) CONFIG_SAH_AMX_TR181_DEVICEINFO_RUN_AS_USER=$(CONFIG_SAH_AMX_TR181_DEVICEINFO_RUN_AS_USER) CONFIG_SAH_AMX_TR181_DEVICEINFO_RUN_AS_GROUP=$(CONFIG_SAH_AMX_TR181_DEVICEINFO_RUN_AS_GROUP) CONFIG_SAH_AMX_TR181_DEVICEINFO_NUMBER_OF_EXTRA_MAC_ADDRESSES=$(CONFIG_SAH_AMX_TR181_DEVICEINFO_NUMBER_OF_EXTRA_MAC_ADDRESSES) CONFIG_SAH_AMX_TR181_DEVICEINFO_REQUIRES_USERS=$(CONFIG_SAH_AMX_TR181_DEVICEINFO_REQUIRES_USERS) CONFIG_PACKAGE_procd=$(CONFIG_PACKAGE_procd))
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
	# prpl-feed: this minimal USP feed ships no Device.Users provider. The stock
	# 'requires "Users.User."' extension makes deviceinfo-manager's pre-service hook
	# block forever ("wait until object 'Users.User.' becomes available"), so it never
	# registers Device.DeviceInfo with the obuspa broker. deviceinfo-manager already
	# runs as root, so the Users lookup is unnecessary — drop the extension.
	rm -f $(1)/etc/amx/deviceinfo-manager/extensions/deviceinfo-manager_requires_users.odl
endef

define Package/$(PKG_NAME)/config
	source "$(SOURCE)/Config.in"
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
