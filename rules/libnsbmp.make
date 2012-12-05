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
PACKAGES-$(PTXCONF_LIBNSBMP) += libnsbmp

#
# Paths and names
#
LIBNSBMP_VERSION	:= 0.0.3
LIBNSBMP_MD5		:= b418fd3f73a42190046e4e1ab98d799e
LIBNSBMP		:= libnsbmp-$(LIBNSBMP_VERSION)
LIBNSBMP_SUFFIX		:= -src.tar.gz
LIBNSBMP_URL		:= http://download.netsurf-browser.org/libs/releases/$(LIBNSBMP)$(LIBNSBMP_SUFFIX)
LIBNSBMP_SOURCE		:= $(SRCDIR)/$(LIBNSBMP).$(LIBNSBMP_SUFFIX)
LIBNSBMP_DIR		:= $(BUILDDIR)/$(LIBNSBMP)
LIBNSBMP_LICENSE	:= MIT

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

LIBNSBMP_MAKE_OPT	:= $(CROSS_ENV) OPTCFLAGS="$(CROSS_CPPFLAGS)" OPTLDFLAGS="$(CROSS_LDFLAGS)" COMPONENT_TYPE=lib-shared
LIBNSBMP_INSTALL_OPT	:= install PREFIX=/usr COMPONENT_TYPE=lib-shared

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libnsbmp.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libnsbmp)
	@$(call install_fixup, libnsbmp,PRIORITY,optional)
	@$(call install_fixup, libnsbmp,SECTION,base)
	@$(call install_fixup, libnsbmp,AUTHOR,"fabricega")
	@$(call install_fixup, libnsbmp,DESCRIPTION,missing)
	@$(call install_lib, libnsbmp, 0, 0, 0644, libnsbmp)
	@$(call install_finish, libnsbmp)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/libnsbmp.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, LIBNSBMP)

# vim: syntax=make
