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
PACKAGES-$(PTXCONF_LIBPARSERUTILS) += libparserutils

#
# Paths and names
#
LIBPARSERUTILS_VERSION	:= 0.1.1
LIBPARSERUTILS_MD5	:= c145e961be0ffee35f6afd638fb74dab
LIBPARSERUTILS		:= libparserutils-$(LIBPARSERUTILS_VERSION)
LIBPARSERUTILS_SUFFIX	:= -src.tar.gz
LIBPARSERUTILS_URL	:= http://download.netsurf-browser.org/libs/releases/libparserutils-0.1.1-src.tar.gz/$(LIBPARSERUTILS)$(LIBPARSERUTILS_SUFFIX)
LIBPARSERUTILS_SOURCE	:= $(SRCDIR)/$(LIBPARSERUTILS).$(LIBPARSERUTILS_SUFFIX)
LIBPARSERUTILS_DIR	:= $(BUILDDIR)/$(LIBPARSERUTILS)
LIBPARSERUTILS_LICENSE	:= MIT

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

LIBPARSERUTILS_MAKE_OPT	:= $(CROSS_ENV) OPTCFLAGS="$(CROSS_CPPFLAGS) -DWITHOUT_ICONV_FILTER" OPTLDFLAGS="$(CROSS_LDFLAGS)" COMPONENT_TYPE=lib-shared
LIBPARSERUTILS_INSTALL_OPT	:= install PREFIX=/usr COMPONENT_TYPE=lib-shared

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libparserutils.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libparserutils)
	@$(call install_fixup, libparserutils,PRIORITY,optional)
	@$(call install_fixup, libparserutils,SECTION,base)
	@$(call install_fixup, libparserutils,AUTHOR,"fabricega")
	@$(call install_fixup, libparserutils,DESCRIPTION,missing)
	@$(call install_lib, libparserutils, 0, 0, 0644, libparserutils)
	@$(call install_finish, libparserutils)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/libparserutils.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, LIBPARSERUTILS)

# vim: syntax=make
