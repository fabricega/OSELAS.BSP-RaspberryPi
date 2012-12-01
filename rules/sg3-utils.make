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
PACKAGES-$(PTXCONF_SG3_UTILS) += sg3-utils

#
# Paths and names
#
SG3_UTILS_VERSION	:= 1.34
SG3_UTILS_MD5		:= 9773898053c3a62159e494aa1c46a97c
SG3_UTILS		:= sg3-utils-$(SG3_UTILS_VERSION)
SG3_UTILS_SUFFIX	:= tgz
SG3_UTILS_URL		:= http://sg.danny.cz/sg/p/sg3_utils-$(SG3_UTILS_VERSION).$(SG3_UTILS_SUFFIX)
SG3_UTILS_SOURCE	:= $(SRCDIR)/$(SG3_UTILS).$(SG3_UTILS_SUFFIX)
SG3_UTILS_DIR		:= $(BUILDDIR)/$(SG3_UTILS)
SG3_UTILS_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
SG3_UTILS_CONF_TOOL	:= autoconf
#SG3_UTILS_CONF_OPT	:= $(CROSS_AUTOCONF_USR)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/sg3-utils.targetinstall:
	@$(call targetinfo)

	@$(call install_init, sg3-utils)
	@$(call install_fixup, sg3-utils,PRIORITY,optional)
	@$(call install_fixup, sg3-utils,SECTION,base)
	@$(call install_fixup, sg3-utils,AUTHOR,"fabricega")
	@$(call install_fixup, sg3-utils,DESCRIPTION,missing)

# FIXME : install test programs
#	@$(call install_copy, sg3-utils, 0, 0, 0755, $(SG3_UTILS_DIR)/foobar, /dev/null)

	@$(call install_lib, sg3-utils, 0, 0, 0644, libsgutils2)

	@$(call install_finish, sg3-utils)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/sg3-utils.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, SG3_UTILS)

# vim: syntax=make
