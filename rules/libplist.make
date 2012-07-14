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
PACKAGES-$(PTXCONF_LIBPLIST) += libplist

#
# Paths and names
#
LIBPLIST_VERSION	:= 1.6
LIBPLIST_MD5		:= 78fe4b8fb50e0bad267ffc6e77081cbe
LIBPLIST		:= libplist-$(LIBPLIST_VERSION)
LIBPLIST_SUFFIX		:= tar.bz2
LIBPLIST_URL		:= http://cgit.sukimashita.com/libplist.git/snapshot//$(LIBPLIST).$(LIBPLIST_SUFFIX)
LIBPLIST_SOURCE		:= $(SRCDIR)/$(LIBPLIST).$(LIBPLIST_SUFFIX)
LIBPLIST_DIR		:= $(BUILDDIR)/$(LIBPLIST)
LIBPLIST_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

#$(LIBPLIST_SOURCE):
#	@$(call targetinfo)
#	@$(call get, LIBPLIST)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

LIBPLIST_ENV	:= $(CROSS_ENV)
LIBPLIST_PATH	:= PATH=$(CROSS_PATH)

#
# cmake
#
LIBPLIST_CONF_TOOL	:= cmake
LIBPLIST_CONF_OPT	= $(CROSS_CMAKE_USR) CC=$(CROSS_CC) CXX=$(CROSS_CXX)

$(STATEDIR)/libplist.prepare:
	@$(call targetinfo)
	@$(call clean, $(LIBPLIST_DIR)/config.cache)
	cd $(LIBPLIST_DIR) && \
		rm -rf build && \
		mkdir -p build && \
	cd $(LIBPLIST_DIR)/build && \
		$(LIBPLIST_ENV) $(LIBPLIST_CONF_TOOL) $(LIBPLIST_CONF_OPT) \
		-DCMAKE_C_FLAGS:STRING="$(CROSS_CPPFLAGS) $(CROSS_CFLAGS)"     \
		-DCMAKE_CXX_FLAGS:STRING="$(CROSS_CPPFLAGS) $(CROSS_CXXFLAGS)" \
		-DCMAKE_INCLUDE_PATH=$(SYSROOT)/usr/include        \
		-DCMAKE_LIBRARY_PATH="$(SYSROOT)/usr/lib $(SYSROOT)/lib"         \
		-DCMAKE_INSTALL_NAME_DIR=$(LIBPLIST_PKGDIR)/usr/lib        \
		-DCMAKE_INSTALL_PREFIX=$(LIBPLIST_PKGDIR)/usr             \
		-DCMAKE_FIND_ROOT_PATH=$(SYSROOT)/usr/lib ..
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/libplist.compile:
	@$(call targetinfo)
	@cd $(LIBPLIST_DIR) && \
		$(MAKE) -C build
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libplist.install:
	@$(call targetinfo)
	@cd $(LIBPLIST_DIR) && \
		$(MAKE) -C build install
	@(cd $(LIBPLIST_PKGDIR);tar cf - *) | (cd $(SYSROOT); tar xpf -)
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libplist.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libplist)
	@$(call install_fixup, libplist,PRIORITY,optional)
	@$(call install_fixup, libplist,SECTION,base)
	@$(call install_fixup, libplist,AUTHOR,"fga")
	@$(call install_fixup, libplist,DESCRIPTION,missing)

	@$(call install_lib, libplist, 0, 0, 0644, libplist)

	@$(call install_finish, libplist)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/libplist.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, LIBPLIST)

# vim: syntax=make
