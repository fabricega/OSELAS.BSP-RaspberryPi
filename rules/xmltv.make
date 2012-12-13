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
PACKAGES-$(PTXCONF_XMLTV) += xmltv

ifdef PTXCONF_XMLTV
ifeq ($(shell which perl 2>/dev/null),)
    $(warning *** perl is mandatory to build xmltv)
    $(warning *** please install perl on HOST)
    $(error )
endif
endif

#
# Paths and names
#
XMLTV_VERSION	:= 0.5.63
XMLTV_MD5	:= d93a74938fb71a250cd0d20aa06c1f61
XMLTV		:= xmltv-$(XMLTV_VERSION)
XMLTV_SUFFIX	:= tar.bz2
XMLTV_URL	:= http://sourceforge.net/projects/xmltv/files/xmltv/$(XMLTV_VERSION)/$(XMLTV).$(XMLTV_SUFFIX)
XMLTV_SOURCE	:= $(SRCDIR)/$(XMLTV).$(XMLTV_SUFFIX)
XMLTV_DIR	:= $(BUILDDIR)/$(XMLTV)
XMLTV_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

#$(XMLTV_SOURCE):
#	@$(call targetinfo)
#	@$(call get, XMLTV)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------
ifdef PTXCONF_XMLTV
PERL_REQ_MODULES += \
	ExtUtils/MakeMaker \
	Carp \
	File/Path \
	Cwd \
	Getopt/Long
endif

#XMLTV_ENV	:= $(CROSS_ENV)
#XMLTV_PATH	:= PATH=$(SYSROOT)/usr/bin:$(HOST_PATH)
#
# autoconf
#
#XMLTV_CONF_TOOL	:= autoconf
#XMLTV_CONF_OPT	:= $(CROSS_AUTOCONF_USR)

$(STATEDIR)/xmltv.prepare:
	@$(call targetinfo)
	cd $(XMLTV_DIR) && \
		$(XMLTV_PATH) \
		PERL5LIB="$(PERL_HOST_PERL5LIB)" $(PERL_HOST) Makefile.PL $(PERL_HOST_OPTS)
#
#	@$(call clean, $(XMLTV_DIR)/config.cache)
#	cd $(XMLTV_DIR) && \
#		$(XMLTV_PATH) $(XMLTV_ENV) \
#		./configure $(XMLTV_CONF_OPT)
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/xmltv.compile:
	@$(call targetinfo)
	cd $(XMLTV_DIR) && \
		$(XMLTV_PATH) $(XMLTV_ENV) \
		PERL5LIB="$(CROSS_PERL_PERL5LIB)" $(MAKE) $(PERL_HOST_OPTS)
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

#$(STATEDIR)/xmltv.install:
#	@$(call targetinfo)
#	@$(call world/install, XMLTV)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/xmltv.targetinstall:
	@$(call targetinfo)

	@$(call install_init, xmltv)
	@$(call install_fixup, xmltv,PRIORITY,optional)
	@$(call install_fixup, xmltv,SECTION,base)
	@$(call install_fixup, xmltv,AUTHOR,"fabricega")
	@$(call install_fixup, xmltv,DESCRIPTION,missing)

	@$(call install_copy, xmltv, 0, 0, 0755, $(XMLTV_DIR)/foobar, /dev/null)

	@$(call install_finish, xmltv)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/xmltv.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, XMLTV)

# vim: syntax=make
