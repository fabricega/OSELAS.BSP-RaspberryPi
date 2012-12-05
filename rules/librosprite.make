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
PACKAGES-$(PTXCONF_LIBROSPRITE) += librosprite

#
# Paths and names
#
LIBROSPRITE_VERSION	:= 0.0.2
LIBROSPRITE_MD5		:= 4b20923a38dc5707739d974fbfbfb340
LIBROSPRITE		:= librosprite-$(LIBROSPRITE_VERSION)
LIBROSPRITE_SUFFIX	:= -src.tar.gz
LIBROSPRITE_URL		:= http://download.netsurf-browser.org/libs/releases/$(LIBROSPRITE)$(LIBROSPRITE_SUFFIX)
LIBROSPRITE_SOURCE	:= $(SRCDIR)/$(LIBROSPRITE).$(LIBROSPRITE_SUFFIX)
LIBROSPRITE_DIR		:= $(BUILDDIR)/$(LIBROSPRITE)
LIBROSPRITE_LICENSE	:= MIT

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

LIBROSPRITE_MAKE_OPT		:= $(CROSS_ENV)
LIBROSPRITE_INSTALL_OPT		:= install PREFIX=/usr

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/librosprite.targetinstall:
	@$(call targetinfo)

#	@$(call install_init, librosprite)
#	@$(call install_fixup, librosprite,PRIORITY,optional)
#	@$(call install_fixup, librosprite,SECTION,base)
#	@$(call install_fixup, librosprite,AUTHOR,"fabricega")
#	@$(call install_fixup, librosprite,DESCRIPTION,missing)
#
#	@$(call install_copy, librosprite, 0, 0, 0755, $(LIBROSPRITE_DIR)/foobar, /dev/null)
#
#	@$(call install_finish, librosprite)
#
	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/librosprite.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, LIBROSPRITE)

# vim: syntax=make
