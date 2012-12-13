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
HOST_PACKAGES-$(PTXCONF_HOST_LIBTERM_READKEY_PERL) += host-libterm-readkey-perl

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

#$(STATEDIR)/host-libterm-readkey-perl.extract:
#	@$(call targetinfo)
#	@$(call clean, $(HOST_LIBTERM_READKEY_PERL_DIR))
#	@$(call extract, LIBTERM_READKEY_PERL, $(HOST_BUILDDIR))
#	@$(call patchin, LIBTERM_READKEY_PERL, $(HOST_LIBTERM_READKEY_PERL_DIR))
#	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#HOST_LIBTERM_READKEY_PERL_CONF_ENV	:= $(HOST_ENV)

#
# autoconf
#
#HOST_LIBTERM_READKEY_PERL_CONF_TOOL	:= autoconf
#HOST_LIBTERM_READKEY_PERL_CONF_OPT	:= $(HOST_AUTOCONF)

$(STATEDIR)/host-libterm-readkey-perl.prepare:
	@$(call targetinfo)
	cd $(HOST_LIBTERM_READKEY_PERL_DIR) && \
		$(HOST_LIBTERM_READKEY_PERL_PATH) $(HOST_LIBTERM_READKEY_PERL_ENV) \
		PERL5LIB="$(PERL_HOST_PERL5LIB)" $(PERL_HOST) Makefile.PL $(PERL_HOST_OPTS)
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/host-libterm-readkey-perl.compile:
	@$(call targetinfo)
	cd $(HOST_LIBTERM_READKEY_PERL_DIR) && \
		$(HOST_LIBTERM_READKEY_PERL_PATH) $(HOST_LIBTERM_READKEY_PERL_ENV) \
		PERL5LIB="$(PERL_HOST_PERL5LIB)" $(MAKE) $(PERL_HOST_OPTS)
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/host-libterm-readkey-perl.install:
	@$(call targetinfo)
	cd $(HOST_LIBTERM_READKEY_PERL_DIR) && \
		$(HOST_LIBTERM_READKEY_PERL_PATH) $(HOST_LIBTERM_READKEY_PERL_ENV) \
		PERL5LIB="$(PERL_HOST_PERL5LIB)" $(MAKE)  DESTDIR="$(HOST_LIBTERM_READKEY_PERL_PKGDIR)" $(PERL_HOST_OPTS) install
	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/host-libterm-readkey-perl.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, HOST_LIBTERM_READKEY_PERL)

# vim: syntax=make
