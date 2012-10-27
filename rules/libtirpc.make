# -*-makefile-*-
#
# Copyright (C) 2012 by Fga
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_LIBTIRPC) += libtirpc

#
# Paths and names
#
LIBTIRPC_VERSION	:= 0.2.2
LIBTIRPC_MD5		:= 74c41c15c2909f7d11d9c7bfa7db6273
LIBTIRPC		:= libtirpc-$(LIBTIRPC_VERSION)
LIBTIRPC_SUFFIX		:= tar.bz2
LIBTIRPC_URL		:= http://switch.dl.sourceforge.net/project/libtirpc/libtirpc/$(LIBTIRPC_VERSION)/$(LIBTIRPC).$(LIBTIRPC_SUFFIX)
LIBTIRPC_SOURCE		:= $(SRCDIR)/$(LIBTIRPC).$(LIBTIRPC_SUFFIX)
LIBTIRPC_DIR		:= $(BUILDDIR)/$(LIBTIRPC)
LIBTIRPC_LICENSE	:= BSD

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

#$(LIBTIRPC_SOURCE):
#	@$(call targetinfo)
#	@$(call get, LIBTIRPC)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#LIBTIRPC_CONF_ENV	:= $(CROSS_ENV)

#
# autoconf
#
LIBTIRPC_CONF_TOOL	:= autoconf
#LIBTIRPC_CONF_OPT	:= $(CROSS_AUTOCONF_USR)

#$(STATEDIR)/libtirpc.prepare:
#	@$(call targetinfo)
#	@$(call clean, $(LIBTIRPC_DIR)/config.cache)
#	cd $(LIBTIRPC_DIR) && \
#		$(LIBTIRPC_PATH) $(LIBTIRPC_ENV) \
#		./configure $(LIBTIRPC_CONF_OPT)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

#$(STATEDIR)/libtirpc.compile:
#	@$(call targetinfo)
#	@$(call world/compile, LIBTIRPC)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

#$(STATEDIR)/libtirpc.install:
#	@$(call targetinfo)
#	@$(call world/install, LIBTIRPC)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libtirpc.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libtirpc)
	@$(call install_fixup, libtirpc,PRIORITY,optional)
	@$(call install_fixup, libtirpc,SECTION,base)
	@$(call install_fixup, libtirpc,AUTHOR,"Fga")
	@$(call install_fixup, libtirpc,DESCRIPTION,missing)

	@$(call install_copy, libtirpc, 0, 0, 0644, -, /etc/netconfig)

	@$(call install_lib, libtirpc, 0, 0, 0644, libtirpc)

	@$(call install_finish, libtirpc)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/libtirpc.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, LIBTIRPC)

# vim: syntax=make
