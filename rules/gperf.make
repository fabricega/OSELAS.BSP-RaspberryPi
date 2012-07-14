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
PACKAGES-$(PTXCONF_GPERF) += gperf

#
# Paths and names
#
GPERF_VERSION	:= 3.0.4
GPERF_MD5	:= c1f1db32fb6598d6a93e6e88796a8632
GPERF		:= gperf-$(GPERF_VERSION)
GPERF_SUFFIX	:= tar.gz
GPERF_URL	:= http://ftp.gnu.org/pub/gnu/gperf/$(GPERF).$(GPERF_SUFFIX)
GPERF_SOURCE	:= $(SRCDIR)/$(GPERF).$(GPERF_SUFFIX)
GPERF_DIR	:= $(BUILDDIR)/$(GPERF)
GPERF_LICENSE	:= GPL

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

#$(GPERF_SOURCE):
#	@$(call targetinfo)
#	@$(call get, GPERF)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#GPERF_CONF_ENV	:= $(CROSS_ENV)

#
# autoconf
#
GPERF_CONF_TOOL	:= autoconf
#GPERF_CONF_OPT	:= $(CROSS_AUTOCONF_USR)

#$(STATEDIR)/gperf.prepare:
#	@$(call targetinfo)
#	@$(call clean, $(GPERF_DIR)/config.cache)
#	cd $(GPERF_DIR) && \
#		$(GPERF_PATH) $(GPERF_ENV) \
#		./configure $(GPERF_CONF_OPT)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

#$(STATEDIR)/gperf.compile:
#	@$(call targetinfo)
#	@$(call world/compile, GPERF)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

#$(STATEDIR)/gperf.install:
#	@$(call targetinfo)
#	@$(call world/install, GPERF)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/gperf.targetinstall:
	@$(call targetinfo)

	@$(call install_init, gperf)
	@$(call install_fixup, gperf,PRIORITY,optional)
	@$(call install_fixup, gperf,SECTION,base)
	@$(call install_fixup, gperf,AUTHOR,"fga")
	@$(call install_fixup, gperf,DESCRIPTION,missing)

	@$(call install_copy, gperf, 0, 0, 0755, -, /usr/bin/gperf)

	@$(call install_finish, gperf)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/gperf.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, GPERF)

# vim: syntax=make
