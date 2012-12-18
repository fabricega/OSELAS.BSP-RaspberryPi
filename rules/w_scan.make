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
PACKAGES-$(PTXCONF_W_SCAN) += w_scan

#
# Paths and names
#
W_SCAN_VERSION	:= 20120605
W_SCAN_MD5	:= 6717b8ac27913f12746ca7e3e8299758
W_SCAN		:= w_scan-$(W_SCAN_VERSION)
W_SCAN_SUFFIX	:= tar.bz2
W_SCAN_URL	:= http://wirbel.htpc-forum.de/w_scan/$(W_SCAN).$(W_SCAN_SUFFIX)
W_SCAN_SOURCE	:= $(SRCDIR)/$(W_SCAN).$(W_SCAN_SUFFIX)
W_SCAN_DIR	:= $(BUILDDIR)/$(W_SCAN)
W_SCAN_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------
W_SCAN_CFLAGS	:= $(CROSS_CFLAGS)
W_SCAN_CFLAGS	+= $(CROSS_CPPFLAGS)
W_SCAN_CFLAGS	+= -I$(SYSROOT)/lib/modules/$(KERNEL_VERSION)/source/include
W_SCAN_ENV	:= $(CROSS_ENV) CFLAGS="$(W_SCAN_CFLAGS)"

#
# autoconf
#
W_SCAN_CONF_OPT	:= $(CROSS_AUTOCONF_USR)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/w_scan.targetinstall:
	@$(call targetinfo)

	@$(call install_init, w_scan)
	@$(call install_fixup, w_scan,PRIORITY,optional)
	@$(call install_fixup, w_scan,SECTION,base)
	@$(call install_fixup, w_scan,AUTHOR,"fabricega")
	@$(call install_fixup, w_scan,DESCRIPTION,missing)

	@$(call install_copy, w_scan, 0, 0, 0755, -, /usr/bin/w_scan)

	@$(call install_finish, w_scan)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/w_scan.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, W_SCAN)

# vim: syntax=make
