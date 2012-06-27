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
PACKAGES-$(PTXCONF_FIRMWARE) += firmware

#
# Paths and names
#
FIRMWARE_VERSION	:= $(call remove_quotes,$(PTXCONF_FIRMWARE_VERSION))
FIRMWARE_MD5		:= $(call remove_quotes,$(PTXCONF_FIRMWARE_MD5))
FIRMWARE		:= firmware-$(FIRMWARE_VERSION)
FIRMWARE_SUFFIX		:= zip
FIRMWARE_URL		:= https://github.com/raspberrypi/firmware/zipball
FIRMWARE_SOURCE		:= $(SRCDIR)/$(FIRMWARE).$(FIRMWARE_SUFFIX)
FIRMWARE_DIR		:= $(BUILDDIR)/$(FIRMWARE)
FIRMWARE_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(FIRMWARE_SOURCE):
	@$(call targetinfo)
	@cd $(SRCDIR) && \
		wget -O $(FIRMWARE_SOURCE) $(FIRMWARE_URL)/$(FIRMWARE_VERSION)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

$(STATEDIR)/firmware.prepare:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/firmware.compile:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/firmware.install:
	@$(call targetinfo)
	@mkdir -p $(FIRMWARE_PKGDIR)/usr
	@cp -a $(FIRMWARE_DIR)/opt/vc/* $(FIRMWARE_PKGDIR)/usr
	@cp -a $(FIRMWARE_DIR)/opt/vc/* $(SYSROOT)/usr
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/firmware.targetinstall:
	@$(call targetinfo)

	@$(call install_init, firmware)
	@$(call install_fixup, firmware,PRIORITY,optional)
	@$(call install_fixup, firmware,SECTION,base)
	@$(call install_fixup, firmware,AUTHOR,"fga")
	@$(call install_fixup, firmware,DESCRIPTION,missing)

ifdef PTXCONF_FIRMWARE_GPULIBS
	@cd $(FIRMWARE_PKGDIR) && \
	 find usr/lib -type f | while read file; do \
	 $(call install_copy, firmware, 0, 0, 0644, -, /$${file}); \
	done;
endif

	@$(call install_finish, firmware)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/firmware.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, FIRMWARE)

# vim: syntax=make
