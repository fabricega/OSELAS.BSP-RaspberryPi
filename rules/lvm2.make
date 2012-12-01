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
PACKAGES-$(PTXCONF_LVM2) += lvm2

#
# Paths and names
#
LVM2_VERSION	:= 2.02.98
LVM2_MD5	:= 1ce5b7f9981e1d02dfd1d3857c8d9fbe
LVM2		:= LVM2.$(LVM2_VERSION)
LVM2_SUFFIX	:= tgz
LVM2_URL	:= ftp://sources.redhat.com/pub/lvm2/$(LVM2).$(LVM2_SUFFIX)
LVM2_SOURCE	:= $(SRCDIR)/$(LVM2).$(LVM2_SUFFIX)
LVM2_DIR	:= $(BUILDDIR)/$(LVM2)
LVM2_LICENSE	:= GPL

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

LVM2_ENV	:= \
	$(CROSS_ENV) \
	CFLAGS="$(CROSS_CFLAGS) $(CROSS_CPPFLAGS)" \
	ac_cv_path_MODPROBE_CMD="/sbin/modprobe"

#
# autoconf
#
LVM2_CONF_TOOL	:= autoconf
LVM2_CONF_OPT	:= $(CROSS_AUTOCONF_USR) \
	--with-confdir=/etc \
	--enable-applib     \
	--enable-cmdlib     \
	--enable-pkgconfig  \
	--enable-udev_sync

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/lvm2.targetinstall:
	@$(call targetinfo)

	@$(call install_init, lvm2)
	@$(call install_fixup, lvm2,PRIORITY,optional)
	@$(call install_fixup, lvm2,SECTION,base)
	@$(call install_fixup, lvm2,AUTHOR,"fabricega")
	@$(call install_fixup, lvm2,DESCRIPTION,missing)

	@$(call install_copy, lvm2, 0, 0, 0755, -, /usr/sbin/dmsetup)

	@$(call install_lib, lvm2, 0, 0, 0644, libdevmapper)

	@$(call install_finish, lvm2)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/lvm2.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, LVM2)

# vim: syntax=make
