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
PACKAGES-$(PTXCONF_LIBSVGTINY) += libsvgtiny

#
# Paths and names
#
LIBSVGTINY_VERSION	:= 0.0.2
LIBSVGTINY_MD5		:= eebc5fa4acdba8b368adba92cf1c2483
LIBSVGTINY		:= libsvgtiny-$(LIBSVGTINY_VERSION)
LIBSVGTINY_SUFFIX	:= -src.tar.gz
LIBSVGTINY_URL		:= http://download.netsurf-browser.org/libs/releases/$(LIBSVGTINY)$(LIBSVGTINY_SUFFIX)
LIBSVGTINY_SOURCE	:= $(SRCDIR)/$(LIBSVGTINY).$(LIBSVGTINY_SUFFIX)
LIBSVGTINY_DIR		:= $(BUILDDIR)/$(LIBSVGTINY)
LIBSVGTINY_LICENSE	:= MIT

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

LIBSVGTINY_MAKE_OPT	:= $(CROSS_ENV) OPTCFLAGS="$(CROSS_CPPFLAGS)" OPTLDFLAGS="$(CROSS_LDFLAGS)" COMPONENT_TYPE=lib-shared
LIBSVGTINY_INSTALL_OPT	:= install PREFIX=/usr COMPONENT_TYPE=lib-shared

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libsvgtiny.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libsvgtiny)
	@$(call install_fixup, libsvgtiny,PRIORITY,optional)
	@$(call install_fixup, libsvgtiny,SECTION,base)
	@$(call install_fixup, libsvgtiny,AUTHOR,"fabricega")
	@$(call install_fixup, libsvgtiny,DESCRIPTION,missing)
	@$(call install_lib, libsvgtiny, 0, 0, 0644, libsvgtiny)
	@$(call install_finish, libsvgtiny)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/libsvgtiny.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, LIBSVGTINY)

# vim: syntax=make
