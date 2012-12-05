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
HOST_PACKAGES-$(PTXCONF_HOST_FLUX) += host-flux

#
# Paths and names
#
HOST_FLUX_VERSION	:= 1.4.2
HOST_FLUX_MD5		:= c7c01ee85b330a1e6c429e48182007c6
HOST_FLUX		:= flux-$(HOST_FLUX_VERSION)
HOST_FLUX_SUFFIX	:= tar.gz
HOST_FLUX_URL		:= http://directfb.org/downloads/Core/flux/$(HOST_FLUX).$(HOST_FLUX_SUFFIX)
HOST_FLUX_SOURCE	:= $(SRCDIR)/$(HOST_FLUX).$(HOST_FLUX_SUFFIX)
HOST_FLUX_DIR		:= $(HOST_BUILDDIR)/$(HOST_FLUX)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

#$(HOST_FLUX_SOURCE):
#	@$(call targetinfo)
#	@$(call get, HOST_FLUX)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#HOST_FLUX_CONF_ENV	:= $(HOST_ENV)

#
# autoconf
#
HOST_FLUX_CONF_TOOL	:= autoconf
#HOST_FLUX_CONF_OPT	:= $(HOST_AUTOCONF)

#$(STATEDIR)/host-flux.prepare:
#	@$(call targetinfo)
#	@$(call clean, $(HOST_FLUX_DIR)/config.cache)
#	cd $(HOST_FLUX_DIR) && \
#		$(HOST_FLUX_PATH) $(HOST_FLUX_ENV) \
#		./configure $(HOST_FLUX_CONF_OPT)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

#$(STATEDIR)/host-flux.compile:
#	@$(call targetinfo)
#	@$(call world/compile, HOST_FLUX)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

#$(STATEDIR)/host-flux.install:
#	@$(call targetinfo)
#	@$(call world/install, HOST_FLUX)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/host-flux.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, HOST_FLUX)

# vim: syntax=make
