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
PACKAGES-$(PTXCONF_JASPER) += jasper

#
# Paths and names
#
JASPER_VERSION	:= 1.900.1
JASPER_MD5	:= a342b2b4495b3e1394e161eb5d85d754
JASPER		:= jasper-$(JASPER_VERSION)
JASPER_SUFFIX	:= zip
JASPER_URL	:= http://www.ece.uvic.ca/~mdadams/jasper/software/$(JASPER).$(JASPER_SUFFIX)
JASPER_SOURCE	:= $(SRCDIR)/$(JASPER).$(JASPER_SUFFIX)
JASPER_DIR	:= $(BUILDDIR)/$(JASPER)
JASPER_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

#$(JASPER_SOURCE):
#	@$(call targetinfo)
#	@$(call get, JASPER)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#JASPER_CONF_ENV	:= $(CROSS_ENV)

#
# autoconf
#
JASPER_CONF_TOOL	:= autoconf
#JASPER_CONF_OPT	:= $(CROSS_AUTOCONF_USR)

#$(STATEDIR)/jasper.prepare:
#	@$(call targetinfo)
#	@$(call clean, $(JASPER_DIR)/config.cache)
#	cd $(JASPER_DIR) && \
#		$(JASPER_PATH) $(JASPER_ENV) \
#		./configure $(JASPER_CONF_OPT)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

#$(STATEDIR)/jasper.compile:
#	@$(call targetinfo)
#	@$(call world/compile, JASPER)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

#$(STATEDIR)/jasper.install:
#	@$(call targetinfo)
#	@$(call world/install, JASPER)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/jasper.targetinstall:
	@$(call targetinfo)

	@$(call install_init, jasper)
	@$(call install_fixup, jasper,PRIORITY,optional)
	@$(call install_fixup, jasper,SECTION,base)
	@$(call install_fixup, jasper,AUTHOR,"fga")
	@$(call install_fixup, jasper,DESCRIPTION,missing)

	@$(call install_copy, jasper, 0, 0, 0755, -, /usr/bin/imgcmp)
	@$(call install_copy, jasper, 0, 0, 0755, -, /usr/bin/imginfo)
	@$(call install_copy, jasper, 0, 0, 0755, -, /usr/bin/jasper)
	@$(call install_copy, jasper, 0, 0, 0755, -, /usr/bin/tmrdemo)

	@$(call install_finish, jasper)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/jasper.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, JASPER)

# vim: syntax=make
