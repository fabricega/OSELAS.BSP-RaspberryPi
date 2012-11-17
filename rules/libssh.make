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
PACKAGES-$(PTXCONF_LIBSSH) += libssh

#
# Paths and names
#
LIBSSH_VERSION	:= 0.5.2
LIBSSH_MD5	:= 38b67c48af7a9204660a3e08f97ceba6
LIBSSH		:= libssh-$(LIBSSH_VERSION)
LIBSSH_SUFFIX	:= tar.gz
LIBSSH_URL	:= http://www.libssh.org/files/0.5/$(LIBSSH).$(LIBSSH_SUFFIX)
LIBSSH_SOURCE	:= $(SRCDIR)/$(LIBSSH).$(LIBSSH_SUFFIX)
LIBSSH_DIR	:= $(BUILDDIR)/$(LIBSSH)
LIBSSH_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

TAGLIB_CONF_TOOL	:= cmake
TAGLIB_CONF_OPT	= \
	$(CROSS_CMAKE_USR) \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DCMAKE_RELEASE_TYPE=Release

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libssh.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libssh)
	@$(call install_fixup, libssh,PRIORITY,optional)
	@$(call install_fixup, libssh,SECTION,base)
	@$(call install_fixup, libssh,AUTHOR,"fabricega")
	@$(call install_fixup, libssh,DESCRIPTION,missing)

	@$(call install_lib, libssh, 0, 0, 0644, libssh)
	@$(call install_lib, libssh, 0, 0, 0644, libssh_threads)

	@$(call install_finish, libssh)

	@$(call touch)

# vim: syntax=make
