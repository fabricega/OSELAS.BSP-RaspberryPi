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
PACKAGES-$(PTXCONF_LIBXML_PARSER_PERL) += libxml-parser-perl

#
# Paths and names
#
LIBXML_PARSER_PERL_VERSION	:= 2.36
LIBXML_PARSER_PERL_MD5		:= 1b868962b658bd87e1563ecd56498ded
LIBXML_PARSER_PERL		:= libxml-parser-perl_$(LIBXML_PARSER_PERL_VERSION)
LIBXML_PARSER_PERL_SUFFIX	:= orig.tar.gz
LIBXML_PARSER_PERL_URL		:= http://ftp.de.debian.org/debian/pool/main/libx/libxml-parser-perl/$(LIBXML_PARSER_PERL).$(LIBXML_PARSER_PERL_SUFFIX)
LIBXML_PARSER_PERL_SOURCE	:= $(SRCDIR)/$(LIBXML_PARSER_PERL).$(LIBXML_PARSER_PERL_SUFFIX)
LIBXML_PARSER_PERL_DIR		:= $(BUILDDIR)/$(LIBXML_PARSER_PERL)
LIBXML_PARSER_PERL_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

#$(LIBXML_PARSER_PERL_SOURCE):
#	@$(call targetinfo)
#	@$(call get, LIBXML_PARSER_PERL)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

LIBXML_PARSER_PERL_ENV	:= $(CROSS_ENV)

#
# autoconf
#
#LIBXML_PARSER_PERL_CONF_TOOL	:= autoconf
#LIBXML_PARSER_PERL_CONF_OPT	:= $(CROSS_AUTOCONF_USR)

$(STATEDIR)/libxml-parser-perl.prepare:
	@$(call targetinfo)
	cd $(LIBXML_PARSER_PERL_DIR) && \
		$(LIBXML_PARSER_PERL_PATH) $(LIBXML_PARSER_PERL_ENV) \
		PERL5LIB="$(PERL_HOST_PERL5LIB)" $(PERL_HOST) Makefile.PL EXPATLIBPATH=$(SYSROOT)/usr/lib EXPATINCPATH=$(SYSROOT)/usr/include
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/libxml-parser-perl.compile:
	@$(call targetinfo)
	cd $(LIBTERM_READKEY_PERL_DIR) && \
		$(LIBTERM_READKEY_PERL_PATH) $(LIBTERM_READKEY_PERL_ENV) \
		PERL5LIB="$(CROSS_PERL_PERL5LIB)" $(MAKE) $(CROSS_PERL_OPTS)
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libxml-parser-perl.install:
	@$(call targetinfo)
	cd $(LIBTERM_READKEY_PERL_DIR) && \
		$(LIBTERM_READKEY_PERL_PATH) $(LIBTERM_READKEY_PERL_ENV) \
		PERL5LIB="$(CROSS_PERL_PERL5LIB)" $(MAKE) $(CROSS_PERL_OPTS) install
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libxml-parser-perl.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libxml-parser-perl)
	@$(call install_fixup, libxml-parser-perl,PRIORITY,optional)
	@$(call install_fixup, libxml-parser-perl,SECTION,base)
	@$(call install_fixup, libxml-parser-perl,AUTHOR,"fabricega")
	@$(call install_fixup, libxml-parser-perl,DESCRIPTION,missing)

	@$(call install_copy, libxml-parser-perl, 0, 0, 0755, $(LIBXML_PARSER_PERL_DIR)/foobar, /dev/null)

	@$(call install_finish, libxml-parser-perl)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/libxml-parser-perl.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, LIBXML_PARSER_PERL)

# vim: syntax=make
