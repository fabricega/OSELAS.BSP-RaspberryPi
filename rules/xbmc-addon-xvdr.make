# -*-makefile-*-
#
# Copyright (C) 2012 by fabricega
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_XBMC_ADDON_XVDR) += xbmc-addon-xvdr

#
# Paths and names
#
XBMC_ADDON_XVDR_VERSION	:= f14eaf98537b43a0267dcfc391cfa4a08ca07b87
XBMC_ADDON_XVDR_MD5	:= 781a35d05d550185c8b394164f5e3388
XBMC_ADDON_XVDR		:= xbmc-addon-xvdr-$(XBMC_ADDON_XVDR_VERSION)
XBMC_ADDON_XVDR_SUFFIX	:= zip
XBMC_ADDON_XVDR_URL	:= https://github.com/pipelka/xbmc-addon-xvdr/archive/$(XBMC_ADDON_XVDR_VERSION).$(XBMC_ADDON_XVDR_SUFFIX)
XBMC_ADDON_XVDR_SOURCE	:= $(SRCDIR)/$(XBMC_ADDON_XVDR).$(XBMC_ADDON_XVDR_SUFFIX)
XBMC_ADDON_XVDR_DIR	:= $(BUILDDIR)/$(XBMC_ADDON_XVDR)
XBMC_ADDON_XVDR_LICENSE	:= GPLv2

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

XBMC_ADDON_XVDR_ENV		:= $(CROSS_ENV)

#
# autoconf
#
XBMC_ADDON_XVDR_CONF_OPT	:= \
	$(CROSS_AUTOCONF_USR) \
	--prefix=/usr/share/xbmc \
	--disable-static \
	--enable-shared

$(STATEDIR)/xbmc-addon-xvdr.prepare:
	@$(call targetinfo)
	@$(call clean, $(XBMC_ADDON_XVDR_DIR)/config.cache)
	cd $(XBMC_ADDON_XVDR_DIR) && \
		sh autogen.sh
	cd $(XBMC_ADDON_XVDR_DIR) && \
		$(XBMC_ADDON_XVDR_PATH) $(XBMC_ADDON_XVDR_ENV) \
		./configure $(XBMC_ADDON_XVDR_CONF_OPT)
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/xbmc-addon-xvdr.targetinstall:
	@$(call targetinfo)

	@$(call install_init, xbmc-addon-xvdr)
	@$(call install_fixup, xbmc-addon-xvdr,PRIORITY,optional)
	@$(call install_fixup, xbmc-addon-xvdr,SECTION,base)
	@$(call install_fixup, xbmc-addon-xvdr,AUTHOR,"fabricega")
	@$(call install_fixup, xbmc-addon-xvdr,DESCRIPTION,missing)

	@cd $(XBMC_ADDON_XVDR_PKGDIR) && \
	find . -type f | while read file; do \
		$(call install_copy, xbmc-addon-xvdr, 0, 0, 644, \
		$(XBMC_ADDON_XVDR_PKGDIR)/$$file, \
			/$$file); \
	done

	@$(call install_finish, xbmc-addon-xvdr)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/xbmc-addon-xvdr.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, XBMC_ADDON_XVDR)

# vim: syntax=make
