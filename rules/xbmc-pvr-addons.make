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
PACKAGES-$(PTXCONF_XBMC_PVR_ADDONS) += xbmc-pvr-addons

#
# Paths and names
#
XBMC_PVR_ADDONS_VERSION	:= 96774c4f775b156a46fb58151379dece3e773c96
XBMC_PVR_ADDONS_MD5	:= e0fb9692a855f4d30dac068eec104d27
XBMC_PVR_ADDONS		:= xbmc-pvr-addons-$(XBMC_PVR_ADDONS_VERSION)
XBMC_PVR_ADDONS_SUFFIX	:= zip
XBMC_PVR_ADDONS_URL	:= https://github.com/opdenkamp/xbmc-pvr-addons/archive/$(XBMC_PVR_ADDONS_VERSION).$(XBMC_PVR_ADDONS_SUFFIX)
XBMC_PVR_ADDONS_SOURCE	:= $(SRCDIR)/$(XBMC_PVR_ADDONS).$(XBMC_PVR_ADDONS_SUFFIX)
XBMC_PVR_ADDONS_DIR	:= $(BUILDDIR)/$(XBMC_PVR_ADDONS)
XBMC_PVR_ADDONS_LICENSE	:= GPLv3

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

XBMC_PVR_ADDONS_CONF_ENV	:= $(CROSS_ENV)
XBMC_PVR_ADDONS_PATH		:= PATH=$(CROSS_PATH)

#
# autoconf
#
XBMC_PVR_ADDONS_CONF_OPT := \
	$(CROSS_AUTOCONF_USR) \
	--disable-static \
	--enable-addons-with-dependencies \
	--enable-shared

$(STATEDIR)/xbmc-pvr-addons.prepare:
	@$(call targetinfo)
	@$(call clean, $(XBMC_PVR_ADDONS_DIR)/config.cache)
	cd $(XBMC_PVR_ADDONS_DIR) && ./bootstrap
	cd $(XBMC_PVR_ADDONS_DIR) && \
		$(XBMC_PVR_ADDONS_PATH) $(XBMC_PVR_ADDONS_ENV) \
		./configure $(XBMC_PVR_ADDONS_CONF_OPT)
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/xbmc-pvr-addons.install.post:
	@$(call targetinfo)
	@$(call world/install.post, XBMC_PVR_ADDONS)
	@mkdir -p $(XBMC_PVR_ADDONS_PKGDIR)/usr/lib/xbmc/addons
	@mv $(XBMC_PVR_ADDONS_PKGDIR)/usr/lib/pvr* $(XBMC_PVR_ADDONS_PKGDIR)/usr/lib/xbmc/addons
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/xbmc-pvr-addons.targetinstall:
	@$(call targetinfo)

	@$(call install_init, xbmc-pvr-addons)
	@$(call install_fixup, xbmc-pvr-addons,PRIORITY,optional)
	@$(call install_fixup, xbmc-pvr-addons,SECTION,base)
	@$(call install_fixup, xbmc-pvr-addons,AUTHOR,"fabricega")
	@$(call install_fixup, xbmc-pvr-addons,DESCRIPTION,missing)

	@cd $(XBMC_PVR_ADDONS_PKGDIR) && \
	find . -type f | while read file; do \
		$(call install_copy, xbmc-pvr-addons, 0, 0, 755, \
		$(XBMC_PVR_ADDONS_PKGDIR)/$$file, \
			/$$file); \
	done

	@$(call install_finish, xbmc-pvr-addons)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/xbmc-pvr-addons.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, XBMC_PVR_ADDONS)

# vim: syntax=make
