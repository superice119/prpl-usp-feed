#
# Copyright (C) 2006-2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=chrony-prpl
PKG_VERSION:=gen_4.6.1_v0.1.0
PKG_RELEASE:=1

PKG_SOURCE:=chrony-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://gitlab.com/prpl-foundation/mirrors/chrony/-/archive/$(PKG_VERSION)
PKG_HASH:=bb78f8de9b8c5a092e7f1a4455721adfd10b930ac5bb87630d3b7bc7af315ad1
PKG_BUILD_DIR:=$(BUILD_DIR)/chrony-$(PKG_VERSION)

PKG_MAINTAINER:=Miroslav Lichvar <mlichvar0@gmail.com>
PKG_LICENSE:=GPL-2.0
PKG_LICENSE_FILES:=COPYING
PKG_CPE_ID:=cpe:/a:tuxfamily:chrony

PKG_BUILD_DEPENDS:=pps-tools
PKG_BUILD_FLAGS:=lto

include $(INCLUDE_DIR)/package.mk

define Package/chrony-prpl
  SUBMENU:=Time Synchronization
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+libcap +libpthread
  USERID:=chrony=323:chrony=323
  TITLE:=A versatile NTP client and server
  URL:=http://chrony.tuxfamily.org/
  PROVIDES:=chrony
  CONFLICTS:=chrony
endef

define Package/chrony-prpl/description
	An NTP client and server designed to perform well in a wide range
	of conditions. It can synchronize the system clock with NTP servers,
	reference clocks, and manual input using wristwatch and keyboard.
endef

CONFIGURE_ARGS+= \
	--host-machine=$(shell echo $(GNU_TARGET_NAME) | sed -e 's/-.*//') \
	--host-release="" \
	--host-system=Linux \
	--sysconfdir=/etc/chrony \
	--prefix=/usr \
	--chronyrundir=/var/run/chrony \
	--disable-nts \
	--disable-readline \
	--disable-rtc \
	--disable-sechash \
	--with-user=chrony

CONFIGURE_VARS+=CPPFLAGS=-DNDEBUG

define Package/chrony-prpl/install
	$(INSTALL_DIR) $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/usr/sbin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/chronyd $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/chronyc $(1)/usr/bin
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/etc/chrony
	$(INSTALL_DIR) $(1)/etc/hotplug.d/iface
	$(INSTALL_BIN) ./files/chrony.hotplug $(1)/etc/hotplug.d/iface/20-chrony
	$(INSTALL_BIN) ./files/chronyd.init $(1)/etc/init.d/chronyd
	$(INSTALL_CONF) ./files/chrony.config $(1)/etc/config/chrony
	$(INSTALL_CONF) ./files/chrony.conf $(1)/etc/chrony/chrony.conf
endef

$(eval $(call BuildPackage,chrony-prpl))
