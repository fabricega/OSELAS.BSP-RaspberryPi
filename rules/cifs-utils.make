# -*-makefile-*-
#
# Copyright (C) 2012 by Alexandre Coffignal
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_CIFS_UTILS) += cifs-utils

#
# Paths and names
#
CIFS_UTILS_VERSION	:= 5.3
CIFS_UTILS_MD5		:= e1a428558a96d2d28ccdaacdc47ea0b7
CIFS_UTILS		:= cifs-utils-$(CIFS_UTILS_VERSION)
CIFS_UTILS_SUFFIX	:= tar.bz2
CIFS_UTILS_URL		:= ftp://ftp.samba.org/pub/linux-cifs/cifs-utils/$(CIFS_UTILS).$(CIFS_UTILS_SUFFIX)
CIFS_UTILS_SOURCE	:= $(SRCDIR)/$(CIFS_UTILS).$(CIFS_UTILS_SUFFIX)
CIFS_UTILS_DIR		:= $(BUILDDIR)/$(CIFS_UTILS)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(CIFS_UTILS_SOURCE):
	@$(call targetinfo)
	@$(call get, CIFS_UTILS)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------
CIFS_UTILS_PATH	:= PATH=$(CROSS_PATH)
CIFS_UTILS_CONF_ENV 	:= \
	$(CROSS_ENV)
#
# autoconf
#
CIFS_UTILS_CONF_TOOL := autoconf
CIFS_UTILS_CONF_OPT := \
	$(CROSS_AUTOCONF_USR)

$(STATEDIR)/cifs-utils.prepare:
	@$(call targetinfo)
	@$(call world/prepare, CIFS_UTILS)
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/cifs-utils.targetinstall:
	@$(call targetinfo)
	@$(call install_init, cifs-utils)
	@$(call install_fixup, cifs-utils,PRIORITY,optional)
	@$(call install_fixup, cifs-utils,SECTION,base)
	@$(call install_fixup, cifs-utils,AUTHOR,"Alexandre Coffignal <alexandre.github@gmail.com>")
	@$(call install_fixup, cifs-utils,DESCRIPTION,missing)
	@$(call install_copy, cifs-utils, 0, 0, 0755, -, /sbin/mount.cifs)
	@$(call install_finish, cifs-utils)
	@$(call touch)

# vim: syntax=make
