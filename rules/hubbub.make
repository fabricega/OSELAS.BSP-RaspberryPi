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
PACKAGES-$(PTXCONF_HUBBUB) += hubbub

#
# Paths and names
#
HUBBUB_VERSION	:= 0.1.2
HUBBUB_MD5	:= 94e2819843f1e675dcccd2e569c9a0a2
HUBBUB		:= hubbub-$(HUBBUB_VERSION)
HUBBUB_SUFFIX	:= -src.tar.gz
HUBBUB_URL	:= http://download.netsurf-browser.org/libs/releases/$(HUBBUB)$(HUBBUB_SUFFIX)
HUBBUB_SOURCE	:= $(SRCDIR)/$(HUBBUB).$(HUBBUB_SUFFIX)
HUBBUB_DIR	:= $(BUILDDIR)/$(HUBBUB)
HUBBUB_LICENSE	:= MIT

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

HUBBUB_MAKE_OPT		:= $(CROSS_ENV) OPTCFLAGS="$(CROSS_CPPFLAGS)" OPTLDFLAGS="$(CROSS_LDFLAGS)" COMPONENT_TYPE=lib-shared
HUBBUB_INSTALL_OPT	:= install PREFIX=/usr COMPONENT_TYPE=lib-shared

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/hubbub.targetinstall:
	@$(call targetinfo)

	@$(call install_init, hubbub)
	@$(call install_fixup, hubbub,PRIORITY,optional)
	@$(call install_fixup, hubbub,SECTION,base)
	@$(call install_fixup, hubbub,AUTHOR,"fabricega")
	@$(call install_fixup, hubbub,DESCRIPTION,missing)
	@$(call install_lib, hubbub, 0, 0, 0644, libhubbub)
	@$(call install_finish, hubbub)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/hubbub.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, HUBBUB)

# vim: syntax=make
