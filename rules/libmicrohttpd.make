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
PACKAGES-$(PTXCONF_LIBMICROHTTPD) += libmicrohttpd

#
# Paths and names
#
LIBMICROHTTPD_VERSION	:= 0.4.6
LIBMICROHTTPD_MD5	:= 61698da6aa04744ea076c327f66fc05a
LIBMICROHTTPD		:= libmicrohttpd-$(LIBMICROHTTPD_VERSION)
LIBMICROHTTPD_SUFFIX	:= tar.gz
LIBMICROHTTPD_URL	:= http://ftp.gnu.org/gnu/libmicrohttpd/$(LIBMICROHTTPD).$(LIBMICROHTTPD_SUFFIX)
LIBMICROHTTPD_SOURCE	:= $(SRCDIR)/$(LIBMICROHTTPD).$(LIBMICROHTTPD_SUFFIX)
LIBMICROHTTPD_DIR	:= $(BUILDDIR)/$(LIBMICROHTTPD)
LIBMICROHTTPD_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

#$(LIBMICROHTTPD_SOURCE):
#	@$(call targetinfo)
#	@$(call get, LIBMICROHTTPD)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#LIBMICROHTTPD_CONF_ENV	:= $(CROSS_ENV)

#
# autoconf
#
LIBMICROHTTPD_CONF_TOOL	:= autoconf
#LIBMICROHTTPD_CONF_OPT	:= $(CROSS_AUTOCONF_USR)

#$(STATEDIR)/libmicrohttpd.prepare:
#	@$(call targetinfo)
#	@$(call clean, $(LIBMICROHTTPD_DIR)/config.cache)
#	cd $(LIBMICROHTTPD_DIR) && \
#		$(LIBMICROHTTPD_PATH) $(LIBMICROHTTPD_ENV) \
#		./configure $(LIBMICROHTTPD_CONF_OPT)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

#$(STATEDIR)/libmicrohttpd.compile:
#	@$(call targetinfo)
#	@$(call world/compile, LIBMICROHTTPD)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

#$(STATEDIR)/libmicrohttpd.install:
#	@$(call targetinfo)
#	@$(call world/install, LIBMICROHTTPD)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libmicrohttpd.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libmicrohttpd)
	@$(call install_fixup, libmicrohttpd,PRIORITY,optional)
	@$(call install_fixup, libmicrohttpd,SECTION,base)
	@$(call install_fixup, libmicrohttpd,AUTHOR,"fga")
	@$(call install_fixup, libmicrohttpd,DESCRIPTION,missing)

	@$(call install_lib, libmicrohttpd, 0, 0, 0644, libmicrohttpd)

	@$(call install_finish, libmicrohttpd)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/libmicrohttpd.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, LIBMICROHTTPD)

# vim: syntax=make
