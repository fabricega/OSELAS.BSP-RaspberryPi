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
PACKAGES-$(PTXCONF_TINYXML) += tinyxml

#
# Paths and names
#
TINYXML_VERSION	:= 2.6.2
TINYXML_MD5	:= c1b864c96804a10526540c664ade67f0
TINYXML		:= tinyxml-$(TINYXML_VERSION)
TINYXML_SUFFIX	:= tar.gz
TINYXML_URL	:= http://sourceforge.net/projects/tinyxml/files/tinyxml/$(TINYXML_VERSION)/tinyxml_2_6_2.tar.gz
TINYXML_SOURCE	:= $(SRCDIR)/$(TINYXML).$(TINYXML_SUFFIX)
TINYXML_DIR	:= $(BUILDDIR)/$(TINYXML)
TINYXML_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

#$(TINYXML_SOURCE):
#	@$(call targetinfo)
#	@$(call get, TINYXML)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

TINYXML_ENV	:= $(CROSS_ENV)
TINYXML_PATH	:= PATH=$(CROSS_PATH)

#
# autoconf
#
#TINYXML_CONF_TOOL	:= autoconf
#TINYXML_CONF_OPT	:= $(CROSS_AUTOCONF_USR)

$(STATEDIR)/tinyxml.prepare:
	@$(call targetinfo)
#	@$(call clean, $(TINYXML_DIR)/config.cache)
#	cd $(TINYXML_DIR) && \
#		$(TINYXML_PATH) $(TINYXML_ENV) \
#		./configure $(TINYXML_CONF_OPT)
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/tinyxml.compile:
	@$(call targetinfo)
	cd $(TINYXML_DIR) && \
		$(TINYXML_PATH) $(TINYXML_ENV) \
		$(MAKE) $(TINYXML_CONF_OPT) CFLAGS="$(CFLAGS) -DTIXML_USE_STL" CXXFLAGS="$(CXXFLAGS) -DTIXML_USE_STL" LDFLAGS="$(LDFLAGS)" LIBS="-ldl -lc -lstdc++"
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

#$(STATEDIR)/tinyxml.install:
#	@$(call targetinfo)
#	@$(call world/install, TINYXML)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/tinyxml.targetinstall:
	@$(call targetinfo)

	@$(call install_init, tinyxml)
	@$(call install_fixup, tinyxml,PRIORITY,optional)
	@$(call install_fixup, tinyxml,SECTION,base)
	@$(call install_fixup, tinyxml,AUTHOR,"fga")
	@$(call install_fixup, tinyxml,DESCRIPTION,missing)

	@$(call install_lib, tinyxml, 0, 0, 0644, libtinyxml)

	@$(call install_finish, tinyxml)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/tinyxml.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, TINYXML)

# vim: syntax=make
