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
PACKAGES-$(PTXCONF_YAJL) += yajl

#
# Paths and names
#
YAJL_VERSION	:= 2.0.1
YAJL_MD5	:= df6a751e7797b9c2182efd91b5d64017
YAJL		:= yajl-$(YAJL_VERSION)
YAJL_SUFFIX	:= tar.gz
YAJL_URL	:= http://github.com/lloyd/yajl/tarball/$(YAJL_VERSION)/$(YAJL).$(YAJL_SUFFIX)
YAJL_SOURCE	:= $(SRCDIR)/$(YAJL).$(YAJL_SUFFIX)
YAJL_DIR	:= $(BUILDDIR)/$(YAJL)
YAJL_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

#$(YAJL_SOURCE):
#	@$(call targetinfo)
#	@$(call get, YAJL)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

YAJL_ENV	:= $(CROSS_ENV)
YAJL_PATH	:= PATH=$(CROSS_PATH)
#
# autoconf
#
#YAJL_CONF_TOOL	:= autoconf
#YAJL_CONF_OPT	:= $(CROSS_AUTOCONF_USR)

YAJL_CONF_TOOL	:= cmake
YAJL_CONF_OPT	= \
	$(CROSS_CMAKE_USR)

$(STATEDIR)/yajl.prepare:
	@$(call targetinfo)
	@cd $(YAJL_DIR) && mkdir build
	@cd $(YAJL_DIR)/build && \
		$(YAJL_CONF_TOOL) $(YAJL_CONF_OPT) ..
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/yajl.compile:
	@$(call targetinfo)
	@cd $(YAJL_DIR) && \
		$(YAJL_PATH) $(YAJL_ENV) \
		$(MAKE) -C build
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/yajl.install:
	@$(call targetinfo)
	@cd $(YAJL_DIR) && \
		$(YAJL_PATH) $(YAJL_ENV) \
		$(MAKE) -C build install DESTDIR=$(YAJL_PKGDIR)
	@cd $(YAJL_DIR) && \
		$(YAJL_PATH) $(YAJL_ENV) \
		$(MAKE) -C build install DESTDIR=$(SYSROOT)
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/yajl.targetinstall:
	@$(call targetinfo)

	@$(call install_init, yajl)
	@$(call install_fixup, yajl,PRIORITY,optional)
	@$(call install_fixup, yajl,SECTION,base)
	@$(call install_fixup, yajl,AUTHOR,"fga")
	@$(call install_fixup, yajl,DESCRIPTION,missing)

	@$(call install_lib, yajl, 0, 0, 0644, libyajl)

	@$(call install_finish, yajl)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/yajl.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, YAJL)

# vim: syntax=make
