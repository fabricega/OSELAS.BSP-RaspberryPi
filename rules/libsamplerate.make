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
PACKAGES-$(PTXCONF_LIBSAMPLERATE) += libsamplerate

#
# Paths and names
#
LIBSAMPLERATE_VERSION	:= 0.1.7
LIBSAMPLERATE_MD5	:= 6731a81cb0c622c483b28c0d7f90867d
LIBSAMPLERATE		:= libsamplerate-$(LIBSAMPLERATE_VERSION)
LIBSAMPLERATE_SUFFIX	:= tar.gz
LIBSAMPLERATE_URL	:= http://www.mega-nerd.com/SRC/$(LIBSAMPLERATE).$(LIBSAMPLERATE_SUFFIX)
LIBSAMPLERATE_SOURCE	:= $(SRCDIR)/$(LIBSAMPLERATE).$(LIBSAMPLERATE_SUFFIX)
LIBSAMPLERATE_DIR	:= $(BUILDDIR)/$(LIBSAMPLERATE)
LIBSAMPLERATE_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

#$(LIBSAMPLERATE_SOURCE):
#	@$(call targetinfo)
#	@$(call get, LIBSAMPLERATE)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#LIBSAMPLERATE_CONF_ENV	:= $(CROSS_ENV)

#
# autoconf
#
LIBSAMPLERATE_CONF_TOOL	:= autoconf
#LIBSAMPLERATE_CONF_OPT	:= $(CROSS_AUTOCONF_USR)

#$(STATEDIR)/libsamplerate.prepare:
#	@$(call targetinfo)
#	@$(call clean, $(LIBSAMPLERATE_DIR)/config.cache)
#	cd $(LIBSAMPLERATE_DIR) && \
#		$(LIBSAMPLERATE_PATH) $(LIBSAMPLERATE_ENV) \
#		./configure $(LIBSAMPLERATE_CONF_OPT)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

#$(STATEDIR)/libsamplerate.compile:
#	@$(call targetinfo)
#	@$(call world/compile, LIBSAMPLERATE)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

#$(STATEDIR)/libsamplerate.install:
#	@$(call targetinfo)
#	@$(call world/install, LIBSAMPLERATE)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libsamplerate.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libsamplerate)
	@$(call install_fixup, libsamplerate,PRIORITY,optional)
	@$(call install_fixup, libsamplerate,SECTION,base)
	@$(call install_fixup, libsamplerate,AUTHOR,"fga")
	@$(call install_fixup, libsamplerate,DESCRIPTION,missing)

	@$(call install_lib, libsamplerate, 0, 0, 0644, libsamplerate)

	@$(call install_finish, libsamplerate)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/libsamplerate.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, LIBSAMPLERATE)

# vim: syntax=make
