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
PACKAGES-$(PTXCONF_LIBMODPLUG) += libmodplug

#
# Paths and names
#
LIBMODPLUG_VERSION	:= 0.8.7
LIBMODPLUG_MD5		:= d2d9ccd8da22412999caed076140f786
LIBMODPLUG		:= libmodplug-$(LIBMODPLUG_VERSION)
LIBMODPLUG_SUFFIX	:= tar.gz
LIBMODPLUG_URL		:= http://sourceforge.net/projects/modplug-xmms/files/libmodplug/$(LIBMODPLUG_VERSION)/$(LIBMODPLUG).$(LIBMODPLUG_SUFFIX)
LIBMODPLUG_SOURCE	:= $(SRCDIR)/$(LIBMODPLUG).$(LIBMODPLUG_SUFFIX)
LIBMODPLUG_DIR		:= $(BUILDDIR)/$(LIBMODPLUG)
LIBMODPLUG_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

#$(LIBMODPLUG_SOURCE):
#	@$(call targetinfo)
#	@$(call get, LIBMODPLUG)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#LIBMODPLUG_CONF_ENV	:= $(CROSS_ENV)

#
# autoconf
#
LIBMODPLUG_CONF_TOOL	:= autoconf
#LIBMODPLUG_CONF_OPT	:= $(CROSS_AUTOCONF_USR)

#$(STATEDIR)/libmodplug.prepare:
#	@$(call targetinfo)
#	@$(call clean, $(LIBMODPLUG_DIR)/config.cache)
#	cd $(LIBMODPLUG_DIR) && \
#		$(LIBMODPLUG_PATH) $(LIBMODPLUG_ENV) \
#		./configure $(LIBMODPLUG_CONF_OPT)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

#$(STATEDIR)/libmodplug.compile:
#	@$(call targetinfo)
#	@$(call world/compile, LIBMODPLUG)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

#$(STATEDIR)/libmodplug.install:
#	@$(call targetinfo)
#	@$(call world/install, LIBMODPLUG)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libmodplug.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libmodplug)
	@$(call install_fixup, libmodplug,PRIORITY,optional)
	@$(call install_fixup, libmodplug,SECTION,base)
	@$(call install_fixup, libmodplug,AUTHOR,"fga")
	@$(call install_fixup, libmodplug,DESCRIPTION,missing)

	@$(call install_lib, libmodplug, 0, 0, 0644, libmodplug)

	@$(call install_finish, libmodplug)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/libmodplug.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, LIBMODPLUG)

# vim: syntax=make
