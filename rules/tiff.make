# -*-makefile-*-
#
# Copyright (C) 2012 by fga
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_TIFF) += tiff

#
# Paths and names
#
TIFF_VERSION	:= 3.8.2
TIFF_MD5	:= fbb6f446ea4ed18955e2714934e5b698
TIFF		:= tiff-$(TIFF_VERSION)
TIFF_SUFFIX	:= tar.gz
TIFF_URL	:= http://download.osgeo.org/libtiff//$(TIFF).$(TIFF_SUFFIX)
TIFF_SOURCE	:= $(SRCDIR)/$(TIFF).$(TIFF_SUFFIX)
TIFF_DIR	:= $(BUILDDIR)/$(TIFF)
TIFF_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

#$(TIFF_SOURCE):
#	@$(call targetinfo)
#	@$(call get, TIFF)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#TIFF_CONF_ENV	:= $(CROSS_ENV)

#
# autoconf
#
TIFF_CONF_TOOL	:= autoconf
#TIFF_CONF_OPT	:= $(CROSS_AUTOCONF_USR)

#$(STATEDIR)/tiff.prepare:
#	@$(call targetinfo)
#	@$(call clean, $(TIFF_DIR)/config.cache)
#	cd $(TIFF_DIR) && \
#		$(TIFF_PATH) $(TIFF_ENV) \
#		./configure $(TIFF_CONF_OPT)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

#$(STATEDIR)/tiff.compile:
#	@$(call targetinfo)
#	@$(call world/compile, TIFF)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

#$(STATEDIR)/tiff.install:
#	@$(call targetinfo)
#	@$(call world/install, TIFF)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/tiff.targetinstall:
	@$(call targetinfo)

	@$(call install_init, tiff)
	@$(call install_fixup, tiff,PRIORITY,optional)
	@$(call install_fixup, tiff,SECTION,base)
	@$(call install_fixup, tiff,AUTHOR,"fga")
	@$(call install_fixup, tiff,DESCRIPTION,missing)

# FIXME: install binaries

	@$(call install_lib, tiff, 0, 0, 0644, libtiff)
	@$(call install_lib, tiff, 0, 0, 0644, libtiffxx)

	@$(call install_finish, tiff)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/tiff.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, TIFF)

# vim: syntax=make
