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
PACKAGES-$(PTXCONF_LIBCSS) += libcss

#
# Paths and names
#
LIBCSS_VERSION	:= 0.1.2
LIBCSS_MD5	:= 6e9dd7ed53113fc42fa1d20b3d202475
LIBCSS		:= libcss-$(LIBCSS_VERSION)
LIBCSS_SUFFIX	:= -src.tar.gz
LIBCSS_URL	:= http://download.netsurf-browser.org/libs/releases/$(LIBCSS)$(LIBCSS_SUFFIX)
LIBCSS_SOURCE	:= $(SRCDIR)/$(LIBCSS).$(LIBCSS_SUFFIX)
LIBCSS_DIR	:= $(BUILDDIR)/$(LIBCSS)
LIBCSS_LICENSE	:= MIT

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

LIBCSS_CFLAGS		:= -Wno-error=enum-compare
LIBCSS_MAKE_OPT		:= HOST_CC=$(HOSTCC) $(CROSS_ENV) OPTCFLAGS="$(CROSS_CPPFLAGS) $(LIBCSS_CFLAGS)" OPTLDFLAGS="$(CROSS_LDFLAGS)" COMPONENT_TYPE=lib-shared
LIBCSS_INSTALL_OPT	:= install PREFIX=/usr COMPONENT_TYPE=lib-shared

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libcss.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libcss)
	@$(call install_fixup, libcss,PRIORITY,optional)
	@$(call install_fixup, libcss,SECTION,base)
	@$(call install_fixup, libcss,AUTHOR,"fabricega")
	@$(call install_fixup, libcss,DESCRIPTION,missing)

	@$(call install_lib, libcss, 0, 0, 0644, libcss)

	@$(call install_finish, libcss)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/libcss.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, LIBCSS)

# vim: syntax=make
