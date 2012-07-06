# -*-makefile-*-
#
# Copyright (C) 2011 by alexandre coffignal <alexandre.github@gmail.com>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_ECOWATT) += ecowatt

#
# Paths and names
#
ECOWATT_VERSION	:= 1.0
ECOWATT			:= ecowatt-$(ECOWATT_VERSION)
ECOWATT_SRCDIR	:= $(PTXDIST_WORKSPACE)/local_src/$(ECOWATT)
ECOWATT_DIR		:= $(BUILDDIR)/$(ECOWATT)
ECOWATT_LICENSE	:= GPL

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

$(STATEDIR)/ecowatt.extract:
	@$(call targetinfo)
	rm -fr $(ECOWATT_DIR)
	cp -a $(ECOWATT_SRCDIR) $(ECOWATT_DIR)
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------
ECOWATT_PATH := PATH=$(CROSS_PATH)
ECOWATT_COMPILE_ENV := $(CROSS_ENV)

$(STATEDIR)/ecowatt.prepare:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/ecowatt.compile:
	@$(call targetinfo)
	@cd $(ECOWATT_DIR) && \
		$(ECOWATT_PATH) $(ECOWATT_COMPILE_ENV) \
		$(MAKE)
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/ecowatt.install:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/ecowatt.targetinstall:
	@$(call targetinfo)

	@$(call install_init,  ecowatt)
	@$(call install_fixup, ecowatt,PACKAGE,ecowatt)
	@$(call install_fixup, ecowatt,PRIORITY,optional)
	@$(call install_fixup, ecowatt,VERSION,$(ECOWATT_VERSION))
	@$(call install_fixup, ecowatt,SECTION,base)
	@$(call install_fixup, ecowatt,AUTHOR,"Alexandre Coffignal <alexandre.github@gmail.com>")
	@$(call install_fixup, ecowatt,DEPENDS,)
	@$(call install_fixup, ecowatt,DESCRIPTION,missing)

	@$(call install_copy, ecowatt, 0, 0, 0755, $(ECOWATT_DIR)/ecowatt, /bin/ecowatt,n)

ifdef PTXCONF_ECOWATT_GDC
	@$(call install_archive, ecowatt, 0, 0, $(PTXDIST_WORKSPACE)/local_src/ecowatt_gdc-1.0/ecowatt_gdc-1.0.tgz,)
	@$(call install_alternative, ecowatt, 0, 0, 0700, /usr/bin/display_ecowatt.sh, n);
	@$(call install_alternative, ecowatt, 0, 0, 0700, /etc/crontabrc/rcj/ecowatt.sh, n);
endif

	@$(call install_finish, ecowatt)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/ecowatt.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, ECOWATT)

# vim: syntax=make
