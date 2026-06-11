include $(TOPDIR)/rules.mk

PKG_NAME:=obuspa
PKG_VERSION:=v11.0.2

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/BroadbandForum/obuspa.git
PKG_MIRROR_HASH:=c12714ec3e4d3c039a1a679ea828a06e2f0b9aa93b044bbf36308305732d5033
PKG_SOURCE_VERSION:=92ecb4c0979e35649d3492e84e0f59d373989ec9


PKG_MAINTAINER:=support.prpl@vantiva.com
PKG_LICENSE:=BSD-3-Clause
PKG_LICENSE_FILES:=LICENSE
PKG_FIXUP:=autoreconf
PKG_INSTALL=1

PKG_RELEASE:=3

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  CATEGORY:=prpl Foundation
  SUBMENU:=Utilities
  TITLE:=Provides User Services Platform (USP) Agent.
  DEPENDS +=+libsqlite3
  DEPENDS +=+libcurl
  DEPENDS +=+libmosquitto
  DEPENDS+=+OBUSPA_WEBSOCKET_MTP_SUPPORT:libwebsockets4-full
  MENU:=1
endef

define Package/$(PKG_NAME)/description
	OB-USP-AGENT is a daemon providing a User Services Platform (USP) Agent.
endef

CONFIGURE_ARGS += --disable-bulkdata --disable-coap

ifneq ($(CONFIG_OBUSPA_WEBSOCKET_MTP_SUPPORT),y)
    CONFIGURE_ARGS += --disable-websockets
endif

define Package/$(PKG_NAME)/install
	$(RM) -r $(PKG_INSTALL_DIR)/var
	$(CP) $(PKG_INSTALL_DIR)/* $(1)/
	if [ -d ./files ]; then \
		$(CP)  ./files/* $(1)/; \
	fi
endef

define Package/$(PKG_NAME)/config
	source "$(SOURCE)/Config.in"
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

