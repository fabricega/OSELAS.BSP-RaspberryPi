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
PACKAGES-$(PTXCONF_OMXPLAYER) += omxplayer

#
# Paths and names
#
OMXPLAYER_VERSION	:= $(call remove_quotes,$(PTXCONF_OMXPLAYER_VERSION))
OMXPLAYER_MD5		:= $(call remove_quotes,$(PTXCONF_OMXPLAYER_MD5))
OMXPLAYER		:= omxplayer-$(OMXPLAYER_VERSION)
OMXPLAYER_SUFFIX	:= zip
OMXPLAYER_URL		:= https://github.com/huceke/omxplayer/zipball
OMXPLAYER_SOURCE	:= $(SRCDIR)/$(OMXPLAYER).$(OMXPLAYER_SUFFIX)
OMXPLAYER_DIR		:= $(BUILDDIR)/$(OMXPLAYER)
OMXPLAYER_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(OMXPLAYER_SOURCE):
	@$(call targetinfo)
	@cd $(SRCDIR) && \
		wget -O $(OMXPLAYER_SOURCE) $(OMXPLAYER_URL)/$(OMXPLAYER_VERSION)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

INCLUDES 		:= -I$(SYSROOT)/include -I$(SYSROOT)/usr/include
OMXPLAYER_ENV		:= $(CROSS_ENV) SYSROOT=$(SYSROOT) PREFIX=$(SYSROOT) SDKSTAGE=$(SYSROOT) INCLUDES="$(INCLUDES)" HOST=$(PTXCONF_GNU_TARGET)
OMXPLAYER_PATH		:= PATH=$(CROSS_PATH)

$(STATEDIR)/omxplayer.prepare:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/omxplayer.compile:
	@$(call targetinfo)
#	@cd $(OMXPLAYER_DIR) && \
#		$(OMXPLAYER_PATH) $(OMXPLAYER_ENV) \
#		$(MAKE) ffmpeg
	@cd $(OMXPLAYER_DIR) && \
		$(OMXPLAYER_PATH) $(OMXPLAYER_ENV) \
		$(MAKE) $(OMXPLAYER_TOOLCHAIN)
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

#$(STATEDIR)/omxplayer.install:
#	@$(call targetinfo)
#	@$(call world/install, OMXPLAYER)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/omxplayer.targetinstall:
	@$(call targetinfo)

	@$(call install_init, omxplayer)
	@$(call install_fixup, omxplayer,PRIORITY,optional)
	@$(call install_fixup, omxplayer,SECTION,base)
	@$(call install_fixup, omxplayer,AUTHOR,"fga")
	@$(call install_fixup, omxplayer,DESCRIPTION,missing)

	@$(call install_copy, omxplayer, 0, 0, 0755, -, /usr/bin/omxplayer)
	@$(call install_copy, omxplayer, 0, 0, 0755, -, /usr/bin/omxplayer.bin)

	@$(call install_finish, omxplayer)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/omxplayer.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, OMXPLAYER)

# vim: syntax=make
