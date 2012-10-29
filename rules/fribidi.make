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
PACKAGES-$(PTXCONF_FRIBIDI) += fribidi

#
# Paths and names
#
FRIBIDI_VERSION	:= 0.19.1
FRIBIDI_MD5	:= cc4ccf78216a5de1c6f5e15e7f741f76
FRIBIDI		:= fribidi-$(FRIBIDI_VERSION)
FRIBIDI_SUFFIX	:= tar.gz
FRIBIDI_URL	:= http://fribidi.org/download//$(FRIBIDI).$(FRIBIDI_SUFFIX)
FRIBIDI_SOURCE	:= $(SRCDIR)/$(FRIBIDI).$(FRIBIDI_SUFFIX)
FRIBIDI_DIR	:= $(BUILDDIR)/$(FRIBIDI)
FRIBIDI_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
FRIBIDI_CONF_TOOL	:= autoconf
FRIBIDI_CONF_OPT	:= \
	$(CROSS_AUTOCONF_USR) \
	--with-glib=no

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/fribidi.targetinstall:
	@$(call targetinfo)

	@$(call install_init, fribidi)
	@$(call install_fixup, fribidi,PRIORITY,optional)
	@$(call install_fixup, fribidi,SECTION,base)
	@$(call install_fixup, fribidi,AUTHOR,"fga")
	@$(call install_fixup, fribidi,DESCRIPTION,missing)

# FIXME: install binaries

	@$(call install_lib, fribidi, 0, 0, 0644, libfribidi)

	@$(call install_finish, fribidi)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/fribidi.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, FRIBIDI)

# vim: syntax=make
