# -*-makefile-*-
#
# Copyright (C) 2012 by fabricega
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_LIBNSGIF) += libnsgif

#
# Paths and names
#
LIBNSGIF_VERSION	:= 0.0.3
LIBNSGIF_MD5		:= 1f9efcdbbf0096eee639dc1e263b20dc
LIBNSGIF		:= libnsgif-$(LIBNSGIF_VERSION)
LIBNSGIF_SUFFIX		:= -src.tar.gz
LIBNSGIF_URL		:= http://download.netsurf-browser.org/libs/releases/$(LIBNSGIF)$(LIBNSGIF_SUFFIX)
LIBNSGIF_SOURCE		:= $(SRCDIR)/$(LIBNSGIF).$(LIBNSGIF_SUFFIX)
LIBNSGIF_DIR		:= $(BUILDDIR)/$(LIBNSGIF)
LIBNSGIF_LICENSE	:= MIT

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

LIBNSGIF_MAKE_OPT	:= $(CROSS_ENV) OPTCFLAGS="$(CROSS_CPPFLAGS)" OPTLDFLAGS="$(CROSS_LDFLAGS)" COMPONENT_TYPE=lib-shared
LIBNSGIF_INSTALL_OPT	:= install PREFIX=/usr COMPONENT_TYPE=lib-shared

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libnsgif.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libnsgif)
	@$(call install_fixup, libnsgif,PRIORITY,optional)
	@$(call install_fixup, libnsgif,SECTION,base)
	@$(call install_fixup, libnsgif,AUTHOR,"fabricega")
	@$(call install_fixup, libnsgif,DESCRIPTION,missing)
	@$(call install_lib, libnsgif, 0, 0, 0644, libnsgif)
	@$(call install_finish, libnsgif)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/libnsgif.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, LIBNSGIF)

# vim: syntax=make
