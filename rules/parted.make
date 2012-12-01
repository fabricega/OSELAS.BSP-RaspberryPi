# -*-makefile-*-
#
# Copyright (C) 2010 by Bart vdr. Meulen <bartvdrmeulen@gmail.com>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_PARTED) += parted

#
# Paths and names
#
PARTED_VERSION	:= 3.1
PARTED_MD5	:= 5d89d64d94bcfefa9ce8f59f4b81bdcb
PARTED		:= parted-$(PARTED_VERSION)
PARTED_SUFFIX	:= tar.xz
PARTED_URL	:= $(call ptx/mirror, GNU, parted/$(PARTED).$(PARTED_SUFFIX))
PARTED_SOURCE	:= $(SRCDIR)/$(PARTED).$(PARTED_SUFFIX)
PARTED_DIR	:= $(BUILDDIR)/$(PARTED)
PARTED_LICENSE	:= GPLv3

#
# autoconf
#
PARTED_CONF_TOOL := autoconf
PARTED_CONF_OPT  := \
	$(CROSS_AUTOCONF_USR) \
	--disable-static

ifndef PTXCONF_PARTED_LVM2
PARTED_CONF_OPT	+= --disable-device-mapper
endif

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/parted.targetinstall:
	@$(call targetinfo)

	@$(call install_init, parted)
	@$(call install_fixup, parted,PRIORITY,optional)
	@$(call install_fixup, parted,SECTION,base)
	@$(call install_fixup, parted,AUTHOR,"Bart vdr. Meulen <bartvdrmeulen@gmail.com>")
	@$(call install_fixup, parted,DESCRIPTION,missing)

	@$(call install_copy, parted, 0, 0, 0755, -, /usr/sbin/parted)
	@$(call install_copy, parted, 0, 0, 0755, -, /usr/sbin/partprobe)

	@$(call install_lib, parted, 0, 0, 0644, libparted)

	@$(call install_finish, parted)

	@$(call touch)


# vim: syntax=make
