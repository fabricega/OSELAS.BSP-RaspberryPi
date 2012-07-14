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
PACKAGES-$(PTXCONF_LAME) += lame

#
# Paths and names
#
LAME_VERSION	:= 3.99.5
LAME_MD5	:= 84835b313d4a8b68f5349816d33e07ce
LAME		:= lame-$(LAME_VERSION)
LAME_SUFFIX	:= tar.gz
LAME_URL	:= http://sourceforge.net/projects/lame/files/lame/3.99/$(LAME).$(LAME_SUFFIX)
LAME_SOURCE	:= $(SRCDIR)/$(LAME).$(LAME_SUFFIX)
LAME_DIR		:= $(BUILDDIR)/$(LAME)
LAME_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

#$(LAME_SOURCE):
#	@$(call targetinfo)
#	@$(call get, LAME)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#LAME_CONF_ENV	:= $(CROSS_ENV)

#
# autoconf
#
LAME_CONF_TOOL	:= autoconf
#LAME_CONF_OPT	:= $(CROSS_AUTOCONF_USR)

#$(STATEDIR)/lame.prepare:
#	@$(call targetinfo)
#	@$(call clean, $(LAME_DIR)/config.cache)
#	cd $(LAME_DIR) && \
#		$(LAME_PATH) $(LAME_ENV) \
#		./configure $(LAME_CONF_OPT)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

#$(STATEDIR)/lame.compile:
#	@$(call targetinfo)
#	@$(call world/compile, LAME)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

#$(STATEDIR)/lame.install:
#	@$(call targetinfo)
#	@$(call world/install, LAME)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/lame.targetinstall:
	@$(call targetinfo)

	@$(call install_init, lame)
	@$(call install_fixup, lame,PRIORITY,optional)
	@$(call install_fixup, lame,SECTION,base)
	@$(call install_fixup, lame,AUTHOR,"fga")
	@$(call install_fixup, lame,DESCRIPTION,missing)

	@$(call install_copy, lame, 0, 0, 0755, -, /usr/bin/lame)

	@$(call install_lib, lame, 0, 0, 0644, libmp3lame)

	@$(call install_finish, lame)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/lame.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, LAME)

# vim: syntax=make
