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
PACKAGES-$(PTXCONF_LIBCDIO) += libcdio

#
# Paths and names
#
LIBCDIO_VERSION	:= 0.82
LIBCDIO_MD5	:= 1c29b18e01ab2b966162bc727bf3c360
LIBCDIO		:= libcdio-$(LIBCDIO_VERSION)
LIBCDIO_SUFFIX	:= tar.gz
LIBCDIO_URL	:= http://ftp.gnu.org/gnu/libcdio//$(LIBCDIO).$(LIBCDIO_SUFFIX)
LIBCDIO_SOURCE	:= $(SRCDIR)/$(LIBCDIO).$(LIBCDIO_SUFFIX)
LIBCDIO_DIR	:= $(BUILDDIR)/$(LIBCDIO)
LIBCDIO_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

#$(LIBCDIO_SOURCE):
#	@$(call targetinfo)
#	@$(call get, LIBCDIO)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#LIBCDIO_CONF_ENV	:= $(CROSS_ENV)

#
# autoconf
#
LIBCDIO_CONF_TOOL	:= autoconf
#LIBCDIO_CONF_OPT	:= $(CROSS_AUTOCONF_USR)

#$(STATEDIR)/libcdio.prepare:
#	@$(call targetinfo)
#	@$(call clean, $(LIBCDIO_DIR)/config.cache)
#	cd $(LIBCDIO_DIR) && \
#		$(LIBCDIO_PATH) $(LIBCDIO_ENV) \
#		./configure $(LIBCDIO_CONF_OPT)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

#$(STATEDIR)/libcdio.compile:
#	@$(call targetinfo)
#	@$(call world/compile, LIBCDIO)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

#$(STATEDIR)/libcdio.install:
#	@$(call targetinfo)
#	@$(call world/install, LIBCDIO)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libcdio.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libcdio)
	@$(call install_fixup, libcdio,PRIORITY,optional)
	@$(call install_fixup, libcdio,SECTION,base)
	@$(call install_fixup, libcdio,AUTHOR,"fga")
	@$(call install_fixup, libcdio,DESCRIPTION,missing)

# FIXME: install binaries

	@$(call install_lib, libcdio, 0, 0, 0644, libcdio)
	@$(call install_lib, libcdio, 0, 0, 0644, libcdio++)
	@$(call install_lib, libcdio, 0, 0, 0644, libcdio_paranoia)
	@$(call install_lib, libcdio, 0, 0, 0644, libcdio_cdda)
	@$(call install_lib, libcdio, 0, 0, 0644, libiso9660)
	@$(call install_lib, libcdio, 0, 0, 0644, libiso9660++)
	@$(call install_lib, libcdio, 0, 0, 0644, libudf)

	@$(call install_finish, libcdio)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/libcdio.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, LIBCDIO)

# vim: syntax=make
