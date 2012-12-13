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
PACKAGES-$(PTXCONF_LIBTERM_READKEY_PERL) += libterm-readkey-perl

#
# Paths and names
#
LIBTERM_READKEY_PERL_VERSION	:= 2.30
LIBTERM_READKEY_PERL_MD5	:= f0ef2cea8acfbcc58d865c05b0c7e1ff
LIBTERM_READKEY_PERL		:= libterm-readkey-perl_$(LIBTERM_READKEY_PERL_VERSION)
LIBTERM_READKEY_PERL_SUFFIX	:= orig.tar.gz
LIBTERM_READKEY_PERL_URL	:= http://ftp.de.debian.org/debian/pool/main/libt/libterm-readkey-perl/$(LIBTERM_READKEY_PERL).$(LIBTERM_READKEY_PERL_SUFFIX)
LIBTERM_READKEY_PERL_SOURCE	:= $(SRCDIR)/$(LIBTERM_READKEY_PERL).$(LIBTERM_READKEY_PERL_SUFFIX)
LIBTERM_READKEY_PERL_DIR	:= $(BUILDDIR)/$(LIBTERM_READKEY_PERL)
LIBTERM_READKEY_PERL_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

#$(LIBTERM_READKEY_PERL_SOURCE):
#	@$(call targetinfo)
#	@$(call get, LIBTERM_READKEY_PERL)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#LIBTERM_READKEY_PERL_ENV	:= PERL5LIB="$(CROSS_PERL_PERL5LIB)"
#LIBTERM_READKEY_PERL_INSTALL_OPT := install PERL5LIB="$(CROSS_PERL_PERL5LIB)"
#
# autoconf
#
#LIBTERM_READKEY_PERL_CONF_TOOL	:= autoconf
#LIBTERM_READKEY_PERL_CONF_OPT	:= $(CROSS_AUTOCONF_USR)

$(STATEDIR)/libterm-readkey-perl.prepare:
	@$(call targetinfo)
	cd $(LIBTERM_READKEY_PERL_DIR) && \
		$(LIBTERM_READKEY_PERL_PATH) $(LIBTERM_READKEY_PERL_ENV) \
		PERL5LIB="$(CROSS_PERL_PERL5LIB)" $(CROSS_PERL) Makefile.PL
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/libterm-readkey-perl.compile:
	@$(call targetinfo)
	cd $(LIBTERM_READKEY_PERL_DIR) && \
		$(LIBTERM_READKEY_PERL_PATH) $(LIBTERM_READKEY_PERL_ENV) \
		PERL5LIB="$(CROSS_PERL_PERL5LIB)" $(MAKE) $(CROSS_PERL_OPTS)
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libterm-readkey-perl.install:
	@$(call targetinfo)
	cd $(LIBTERM_READKEY_PERL_DIR) && \
		$(LIBTERM_READKEY_PERL_PATH) $(LIBTERM_READKEY_PERL_ENV) \
		PERL5LIB="$(CROSS_PERL_PERL5LIB)" $(MAKE) \
		DESTDIR="$(LIBTERM_READKEY_PERL_PKGDIR)" $(CROSS_PERL_OPTS) install
	cd $(LIBTERM_READKEY_PERL_DIR) && \
		$(LIBTERM_READKEY_PERL_PATH) $(LIBTERM_READKEY_PERL_ENV) \
		PERL5LIB="$(CROSS_PERL_PERL5LIB)" $(MAKE) \
		DESTDIR="$(SYSROOT)" $(CROSS_PERL_OPTS) install
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libterm-readkey-perl.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libterm-readkey-perl)
	@$(call install_fixup, libterm-readkey-perl,PRIORITY,optional)
	@$(call install_fixup, libterm-readkey-perl,SECTION,base)
	@$(call install_fixup, libterm-readkey-perl,AUTHOR,"fabricega")
	@$(call install_fixup, libterm-readkey-perl,DESCRIPTION,missing)

#	@$(call install_copy, libterm-readkey-perl, 0, 0, 0755, $(LIBTERM_READKEY_PERL_PKGDIR)/Term/ReadKey.pm, /usr/lib/perl/Term/ReadKey.pm)

	@cd $(LIBTERM_READKEY_PERL_PKGDIR)/usr/lib/perl && \
	find . -type f | while read file; do \
		$(call install_copy, libterm-readkey-perl, 0, 0, 644, \
		$(LIBTERM_READKEY_PERL_PKGDIR)/usr/lib/perl/$$file, \
			/usr/lib/perl/auto/$$file); \
	done

	@$(call install_finish, libterm-readkey-perl)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/libterm-readkey-perl.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, LIBTERM_READKEY_PERL)

# vim: syntax=make
