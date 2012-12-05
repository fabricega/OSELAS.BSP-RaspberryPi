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
PACKAGES-$(PTXCONF_LIBWAPCAPLET) += libwapcaplet

#
# Paths and names
#
LIBWAPCAPLET_VERSION	:= 0.1.1
LIBWAPCAPLET_MD5	:= 9bec92c029c978c3ac93fee67742e869
LIBWAPCAPLET		:= libwapcaplet-$(LIBWAPCAPLET_VERSION)
LIBWAPCAPLET_SUFFIX	:= -src.tar.gz
LIBWAPCAPLET_URL	:= http://download.netsurf-browser.org/libs/releases/$(LIBWAPCAPLET)$(LIBWAPCAPLET_SUFFIX)
LIBWAPCAPLET_SOURCE	:= $(SRCDIR)/$(LIBWAPCAPLET).$(LIBWAPCAPLET_SUFFIX)
LIBWAPCAPLET_DIR	:= $(BUILDDIR)/$(LIBWAPCAPLET)
LIBWAPCAPLET_LICENSE	:= MIT

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

LIBWAPCAPLET_MAKE_OPT	:= $(CROSS_ENV) OPTCFLAGS="$(CROSS_CPPFLAGS)" OPTLDFLAGS="$(CROSS_LDFLAGS)" COMPONENT_TYPE=lib-shared
LIBWAPCAPLET_INSTALL_OPT	:= install PREFIX=/usr COMPONENT_TYPE=lib-shared

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libwapcaplet.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libwapcaplet)
	@$(call install_fixup, libwapcaplet,PRIORITY,optional)
	@$(call install_fixup, libwapcaplet,SECTION,base)
	@$(call install_fixup, libwapcaplet,AUTHOR,"fabricega")
	@$(call install_fixup, libwapcaplet,DESCRIPTION,missing)
	@$(call install_lib, libwapcaplet, 0, 0, 0644, libwapcaplet)
	@$(call install_finish, libwapcaplet)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/libwapcaplet.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, LIBWAPCAPLET)

# vim: syntax=make
