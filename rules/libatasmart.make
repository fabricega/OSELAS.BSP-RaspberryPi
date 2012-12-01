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
PACKAGES-$(PTXCONF_LIBATASMART) += libatasmart

#
# Paths and names
#
LIBATASMART_VERSION	:= 0.19
LIBATASMART_MD5		:= 53afe2b155c36f658e121fe6def33e77
LIBATASMART		:= libatasmart-$(LIBATASMART_VERSION)
LIBATASMART_SUFFIX	:= tar.xz
LIBATASMART_URL		:= http://0pointer.de/public//$(LIBATASMART).$(LIBATASMART_SUFFIX)
LIBATASMART_SOURCE	:= $(SRCDIR)/$(LIBATASMART).$(LIBATASMART_SUFFIX)
LIBATASMART_DIR		:= $(BUILDDIR)/$(LIBATASMART)
LIBATASMART_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libatasmart.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libatasmart)
	@$(call install_fixup, libatasmart,PRIORITY,optional)
	@$(call install_fixup, libatasmart,SECTION,base)
	@$(call install_fixup, libatasmart,AUTHOR,"fabricega")
	@$(call install_fixup, libatasmart,DESCRIPTION,missing)	
	@$(call install_lib, libatasmart, 0, 0, 0644, libatasmart)
	@$(call install_finish, libatasmart)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/libatasmart.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, LIBATASMART)

# vim: syntax=make
