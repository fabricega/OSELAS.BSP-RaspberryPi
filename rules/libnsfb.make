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
PACKAGES-$(PTXCONF_LIBNSFB) += libnsfb

#
# Paths and names
#
LIBNSFB_VERSION	:= 0.0.2
LIBNSFB_MD5	:= f7c1cbf5a7d26750a9d6e0668dd8760c
LIBNSFB		:= libnsfb-$(LIBNSFB_VERSION)
LIBNSFB_SUFFIX	:= -src.tar.gz
LIBNSFB_URL	:= http://download.netsurf-browser.org/libs/releases/$(LIBNSFB)$(LIBNSFB_SUFFIX)
LIBNSFB_SOURCE	:= $(SRCDIR)/$(LIBNSFB).$(LIBNSFB_SUFFIX)
LIBNSFB_DIR	:= $(BUILDDIR)/$(LIBNSFB)
LIBNSFB_LICENSE	:= MIT

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

LIBNSFB_CFLAGS		:= -Wno-error=cast-align
LIBNSFB_MAKE_OPT	:= $(CROSS_ENV) OPTCFLAGS="$(CROSS_CPPFLAGS) $(LIBNSFB_CFLAGS)" OPTLDFLAGS="$(CROSS_LDFLAGS)" COMPONENT_TYPE=lib-shared
LIBNSFB_INSTALL_OPT	:= install PREFIX=/usr COMPONENT_TYPE=lib-shared

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libnsfb.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libnsfb)
	@$(call install_fixup, libnsfb,PRIORITY,optional)
	@$(call install_fixup, libnsfb,SECTION,base)
	@$(call install_fixup, libnsfb,AUTHOR,"fabricega")
	@$(call install_fixup, libnsfb,DESCRIPTION,missing)
	@$(call install_lib, libnsfb, 0, 0, 0644, libnsfb)
	@$(call install_finish, libnsfb)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/libnsfb.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, LIBNSFB)

# vim: syntax=make
