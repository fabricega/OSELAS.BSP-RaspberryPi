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
PACKAGES-$(PTXCONF_LIBXML_TWIG_PERL) += libxml-twig-perl

#
# Paths and names
#
LIBXML_TWIG_PERL_VERSION	:= 3.34
LIBXML_TWIG_PERL_MD5		:=
LIBXML_TWIG_PERL		:= libxml-twig-perl_$(LIBXML_TWIG_PERL_VERSION)
LIBXML_TWIG_PERL_SUFFIX		:= orig.tar.gz
LIBXML_TWIG_PERL_URL		:= http://ftp.de.debian.org/debian/pool/main/libx/libxml-twig-perl/$(LIBXML_TWIG_PERL).$(LIBXML_TWIG_PERL_SUFFIX)
LIBXML_TWIG_PERL_SOURCE		:= $(SRCDIR)/$(LIBXML_TWIG_PERL).$(LIBXML_TWIG_PERL_SUFFIX)
LIBXML_TWIG_PERL_DIR		:= $(BUILDDIR)/$(LIBXML_TWIG_PERL)
LIBXML_TWIG_PERL_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

#$(LIBXML_TWIG_PERL_SOURCE):
#	@$(call targetinfo)
#	@$(call get, LIBXML_TWIG_PERL)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#LIBXML_TWIG_PERL_CONF_ENV	:= $(CROSS_ENV)

#
# autoconf
#
#LIBXML_TWIG_PERL_CONF_TOOL	:= autoconf
#LIBXML_TWIG_PERL_CONF_OPT	:= $(CROSS_AUTOCONF_USR)

$(STATEDIR)/libxml-twig-perl.prepare:
	@$(call targetinfo)
	cd $(LIBXML_TWIG_PERL_DIR) && \
		$(LIBXML_TWIG_PERL_PATH) $(LIBXML_TWIG_PERL_ENV) \
		PERL5LIB="$(CROSS_PERL_PERL5LIB)" $(CROSS_PERL) Makefile.PL
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

#$(STATEDIR)/libxml-twig-perl.compile:
#	@$(call targetinfo)
#	@$(call world/compile, LIBXML_TWIG_PERL)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

#$(STATEDIR)/libxml-twig-perl.install:
#	@$(call targetinfo)
#	@$(call world/install, LIBXML_TWIG_PERL)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libxml-twig-perl.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libxml-twig-perl)
	@$(call install_fixup, libxml-twig-perl,PRIORITY,optional)
	@$(call install_fixup, libxml-twig-perl,SECTION,base)
	@$(call install_fixup, libxml-twig-perl,AUTHOR,"fabricega")
	@$(call install_fixup, libxml-twig-perl,DESCRIPTION,missing)

	@$(call install_copy, libxml-twig-perl, 0, 0, 0755, $(LIBXML_TWIG_PERL_DIR)/foobar, /dev/null)

	@$(call install_finish, libxml-twig-perl)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/libxml-twig-perl.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, LIBXML_TWIG_PERL)

# vim: syntax=make
