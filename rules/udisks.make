# -*-makefile-*-
#
# Copyright (C) 2010 by Michael Olbrich <m.olbrich@pengutronix.de>>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_UDISKS) += udisks

#
# Paths and names
#
#UDISKS_VERSION	:= 1.0.0
#UDISKS_MD5	:= a33fac347956e015f40e56a86d63f8ff
UDISKS_VERSION	:= 1.0.4
UDISKS_MD5	:= 86c63b2b5484f2060499a052b5b6256b
UDISKS		:= udisks-$(UDISKS_VERSION)
UDISKS_SUFFIX	:= tar.gz
UDISKS_URL	:= http://hal.freedesktop.org/releases/$(UDISKS).$(UDISKS_SUFFIX)
UDISKS_SOURCE	:= $(SRCDIR)/$(UDISKS).$(UDISKS_SUFFIX)
UDISKS_DIR	:= $(BUILDDIR)/$(UDISKS)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(UDISKS_SOURCE):
	@$(call targetinfo)
	@$(call get, UDISKS)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
UDISKS_AUTOCONF := \
	$(CROSS_AUTOCONF_USR) \
	$(GLOBAL_LARGE_FILE_OPTION) \
	DEVMAPPER_CFLAGS="$(CROSS_CFLAGS) -I$(SYSROOT)/usr/include" \
	DEVMAPPER_LIBS="-L$(SYSROOT)/usr/lib -ldevmapper"

ifdef PTXCONF_LVM2
UDISKS_AUTOCONF += --enable-lvm2
endif

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/udisks.targetinstall:
	@$(call targetinfo)

	@$(call install_init,  udisks)
	@$(call install_fixup, udisks,PRIORITY,optional)
	@$(call install_fixup, udisks,SECTION,base)
	@$(call install_fixup, udisks,AUTHOR,"Michael Olbrich <m.olbrich@pengutronix.de>")
	@$(call install_fixup, udisks,DESCRIPTION,missing)

	@$(call install_copy, udisks, 0, 0, 0755, -, \
		/usr/bin/udisks)
	@$(call install_copy, udisks, 0, 0, 0755, -, \
		/sbin/umount.udisks)

	@$(call install_copy, udisks, 0, 0, 0755, -, \
		/usr/libexec/udisks-daemon)
	@$(call install_copy, udisks, 0, 0, 0755, -, \
		/usr/libexec/udisks-helper-change-filesystem-label)
	@$(call install_copy, udisks, 0, 0, 0755, -, \
		/usr/libexec/udisks-helper-change-luks-password)
	@$(call install_copy, udisks, 0, 0, 0755, -, \
		/usr/libexec/udisks-helper-drive-poll)
	@$(call install_copy, udisks, 0, 0, 0755, -, \
		/usr/libexec/udisks-helper-fstab-mounter)
	@$(call install_copy, udisks, 0, 0, 0755, -, \
		/usr/libexec/udisks-helper-linux-md-check)
	@$(call install_copy, udisks, 0, 0, 0755, -, \
		/usr/libexec/udisks-helper-linux-md-remove-component)
	@$(call install_copy, udisks, 0, 0, 0755, -, \
		/usr/libexec/udisks-helper-mkfs)

	@$(call install_copy, udisks, 0, 0, 0644, -, \
		/lib/udev/rules.d/80-udisks.rules)

	@$(call install_copy, udisks, 0, 0, 0644, -, \
		/etc/dbus-1/system.d/org.freedesktop.UDisks.conf)
	@$(call install_copy, udisks, 0, 0, 0644, -, \
		/usr/share/dbus-1/interfaces/org.freedesktop.UDisks.xml)
	@$(call install_copy, udisks, 0, 0, 0644, -, \
		/usr/share/dbus-1/interfaces/org.freedesktop.UDisks.Device.xml)
	@$(call install_copy, udisks, 0, 0, 0644, -, \
		/usr/share/dbus-1/system-services/org.freedesktop.UDisks.service)

	@$(call install_copy, udisks, 0, 0, 0644, -, \
		/usr/share/polkit-1/actions/org.freedesktop.udisks.policy)
ifneq ($(call remove_quotes,$(UDISKS_VERSION)),1.0.4)
	@$(call install_copy, udisks, 0, 0, 0644, -, \
		/usr/lib/polkit-1/extensions/libudisks-action-lookup.so)
endif

ifdef PTXCONF_UDISKS_FAKE_OVERLAYFS
	@$(call install_copy, udisks, 0, 0, 0755, /var/tmp/media)
	@$(call install_link, udisks, var/tmp/media, /media)
	@$(call install_link, udisks, ../tmp/udisks, \
		/var/lib/udisks)
	@$(call install_copy, udisks, 0, 0, 0755, \
		/var/tmp/udisks)
else
	@$(call install_copy, udisks, 0, 0, 0755, /media)
	@$(call install_copy, udisks, 0, 0, 0755, \
		/var/lib/udisks)
endif
	@$(call install_copy, udisks, 0, 0, 0755, \
		/var/run/udisks)

ifdef PTXCONF_UDISKS_STARTSCRIPT
	@$(call install_alternative, udisks, 0, 0, 0755, /etc/init.d/automount.sh)
ifdef PTXCONF_INITMETHOD_BBINIT
ifneq ($(call remove_quotes,$(PTXCONF_UDISKS_BBINIT_STARTLINK)),)
	@$(call install_link, udisks, \
		../init.d/automount.sh, \
		/etc/rc.d/$(PTXCONF_UDISKS_BBINIT_STARTLINK))
endif
ifneq ($(call remove_quotes,$(PTXCONF_UDISKS_BBINIT_STOPLINK)),)
	@$(call install_link, udisks, \
		../init.d/automount.sh, \
		/etc/rc.d/$(PTXCONF_UDISKS_BBINIT_STOPLINK))
endif
endif
endif

	@$(call install_finish, udisks)

	@$(call touch)

# vim: syntax=make
