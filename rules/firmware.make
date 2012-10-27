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
	@mkdir -p $(FIRMWARE_PKGDIR)/opt/vc
	@mkdir -p $(FIRMWARE_PKGDIR)/usr/include $(FIRMWARE_PKGDIR)/usr/lib
	@mkdir -p $(SYSROOT)/opt/vc
	@cp -ar $(FIRMWARE_DIR)/opt/vc/* $(FIRMWARE_PKGDIR)/opt/vc/
	@cp -ar $(FIRMWARE_DIR)/opt/vc/* $(SYSROOT)/opt/vc/
	
	# install headers
	@cd $(FIRMWARE_PKGDIR)/usr/include && \
		ls ../../opt/vc/include/ | while read inc; do \
		ln -s ../../opt/vc/include/$$inc $$inc || true; done;
	@cd $(SYSROOT)/usr/include && \
		ls ../../opt/vc/include/ | while read inc; do \
		ln -s ../../opt/vc/include/$$inc $$inc || true; done;
	
	# install libs
	@cd $(FIRMWARE_PKGDIR)/usr/lib && \
		ls ../../opt/vc/lib/ | while read lib; do \
		ln -s ../../opt/vc/lib/$$lib $$lib || true; done;
	@cd $(SYSROOT)/usr/lib && \
		ls ../../opt/vc/lib/ | while read lib; do \
		ln -s ../../opt/vc/lib/$$lib $$lib || true; done;

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
		find opt/vc/lib/ -type f -name *.so | while read file; do \
		$(call install_copy, firmware, 0, 0, 0644, -, /$${file}, n); \
	done;
	@cd $(FIRMWARE_PKGDIR)/opt/vc/lib && \
		ls *.so | while read lib; do \
		$(call install_link, firmware, \
		../../opt/vc/lib/$${lib}, \
		/usr/lib/$${lib}); \
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
