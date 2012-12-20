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
PACKAGES-$(PTXCONF_SSHFS_FUSE) += sshfs-fuse

#
# Paths and names
#
SSHFS_FUSE_VERSION	:= 2.3
SSHFS_FUSE_MD5		:= f72f12fda186dbd92382f70d25662ed3
SSHFS_FUSE		:= sshfs-fuse-$(SSHFS_FUSE_VERSION)
SSHFS_FUSE_SUFFIX	:= tar.gz
SSHFS_FUSE_URL		:= $(call ptx/mirror, SF, fuse/$(SSHFS_FUSE).$(SSHFS_FUSE_SUFFIX))
SSHFS_FUSE_SOURCE	:= $(SRCDIR)/$(SSHFS_FUSE).$(SSHFS_FUSE_SUFFIX)
SSHFS_FUSE_DIR		:= $(BUILDDIR)/$(SSHFS_FUSE)
SSHFS_FUSE_LICENSE	:= GPLv2

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(SSHFS_FUSE_SOURCE):
	@$(call targetinfo)
	@$(call get, SSHFS_FUSE)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
SSHFS_FUSE_CONF_OPT	:= \
	$(CROSS_AUTOCONF_USR) \
	--disable-dependency-tracking

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/sshfs-fuse.targetinstall:
	@$(call targetinfo)

	@$(call install_init, sshfs-fuse)
	@$(call install_fixup, sshfs-fuse,PRIORITY,optional)
	@$(call install_fixup, sshfs-fuse,SECTION,base)
	@$(call install_fixup, sshfs-fuse,AUTHOR,"fabricega")
	@$(call install_fixup, sshfs-fuse,DESCRIPTION,missing)

	@$(call install_copy, sshfs-fuse, 0, 0, 0755, -, /usr/bin/sshfs)

	@$(call install_finish, sshfs-fuse)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/sshfs-fuse.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, SSHFS_FUSE)

# vim: syntax=make
