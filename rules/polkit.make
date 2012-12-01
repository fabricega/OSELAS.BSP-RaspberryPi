# -*-makefile-*-
#
# Copyright (C) 2010 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_POLKIT) += polkit

#
# Paths and names
#
POLKIT_VERSION	:= 0.102
POLKIT_MD5	:= a3726bdb9728c103e58f62131e26693a
POLKIT		:= polkit-$(POLKIT_VERSION)
POLKIT_SUFFIX	:= tar.gz
POLKIT_URL	:= http://hal.freedesktop.org/releases/$(POLKIT).$(POLKIT_SUFFIX)
POLKIT_SOURCE	:= $(SRCDIR)/$(POLKIT).$(POLKIT_SUFFIX)
POLKIT_DIR	:= $(BUILDDIR)/$(POLKIT)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(POLKIT_SOURCE):
	@$(call targetinfo)
	@$(call get, POLKIT)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
POLKIT_AUTOCONF := \
	$(CROSS_AUTOCONF_USR) \
	--enable-shared \
	--enable-static \
	--disable-ansi \
	--disable-verbose-mode \
	--disable-man-pages \
	--disable-gtk-doc \
	--disable-examples \
	--disable-introspection \
	--with-gnu-ld \
	--with-authfw=shadow \
	--with-os-type=ptxdist

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/polkit.targetinstall:
	@$(call targetinfo)

	@$(call install_init, polkit)
	@$(call install_fixup, polkit,PRIORITY,optional)
	@$(call install_fixup, polkit,SECTION,base)
	@$(call install_fixup, polkit,AUTHOR,"Michael Olbrich <m.olbrich@pengutronix.de>")
	@$(call install_fixup, polkit,DESCRIPTION,missing)

# dbus
	@$(call install_copy, polkit, 0, 0, 0644, -, \
		/etc/dbus-1/system.d/org.freedesktop.PolicyKit1.conf)
	@$(call install_copy, polkit, 0, 0, 0644, -, \
		/usr/share/dbus-1/system-services/org.freedesktop.PolicyKit1.service)

# config
	@$(call install_copy, polkit, 0, 0, 0644, -, \
		/etc/polkit-1/localauthority.conf.d/50-localauthority.conf)
	@$(call install_copy, polkit, 0, 0, 0644, -, \
		/etc/polkit-1/nullbackend.conf.d/50-nullbackend.conf)
	@$(call install_copy, polkit, 0, 0, 0644, -, \
		/usr/share/polkit-1/actions/org.freedesktop.policykit.policy)

# libs
	@$(call install_lib, polkit, 0, 0, 0644, libpolkit-agent-1)
	@$(call install_lib, polkit, 0, 0, 0644, libpolkit-backend-1)
	@$(call install_lib, polkit, 0, 0, 0644, libpolkit-gobject-1)

	@$(call install_copy, polkit, 0, 0, 0644, -, \
		/usr/lib/polkit-1/extensions/libnullbackend.so)
ifneq ($(call remove_quotes,$(POLKIT_VERSION)),0.102)
	@$(call install_copy, polkit, 0, 0, 0644, -, \
		/usr/lib/polkit-1/extensions/libpkexec-action-lookup.so)
endif

# binaries
	@$(call install_copy, polkit, 0, 0, 0755, -, /usr/bin/pkaction)
	@$(call install_copy, polkit, 0, 0, 0755, -, /usr/bin/pkcheck)

	@$(call install_copy, polkit, 0, 0, 0755, -, /usr/libexec/polkitd)

# binaries with suid
	@$(call install_copy, polkit, 0, 0, 4755, -, /usr/bin/pkexec)
	@$(call install_copy, polkit, 0, 0, 4755, -, \
		/usr/libexec/polkit-agent-helper-1)

	@$(call install_finish, polkit)

	@$(call touch)

# vim: syntax=make
