# -*-makefile-*-
#
# Copyright (C) 2012 by fabricega
# Derived From buildroot-2012-11: buildroot-2012.11/package/perl
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_PERL) += perl

#
# Paths and names
#
PERL_VERSION_MAJOR	:= 5
PERL_VERSION_MINOR	:= 16
PERL_VERSION_MICRO	:= 1

PERL_VERSION	:= $(PERL_VERSION_MAJOR).$(PERL_VERSION_MINOR).$(PERL_VERSION_MICRO)
PERL_MD5	:= bcc5136007177b0fe2b6fd739fb66b84
PERL		:= perl-$(PERL_VERSION)
PERL_SUFFIX	:= tar.gz
PERL_URL	:= http://www.cpan.org/src/$(PERL_VERSION_MAJOR).0/$(PERL).$(PERL_SUFFIX)
PERL_SOURCE	:= $(SRCDIR)/$(PERL).$(PERL_SUFFIX)
PERL_DIR	:= $(BUILDDIR)/$(PERL)
PERL_LICENSE	:= Artistic

PERL_CROSS_VERSION 	:= 0.7
PERL_CROSS		:= perl-5.$(PERL_VERSION_MINOR).0-cross-$(PERL_CROSS_VERSION)
PERL_CROSS_SUFFIX	:= tar.gz
PERL_CROSS_URL    	:= http://download.berlios.de/perlcross/$(PERL_CROSS).$(PERL_CROSS_SUFFIX)
PERL_CROSS_SOURCE	:= $(SRCDIR)/$(PERL_CROSS).$(PERL_CROSS_SUFFIX)
PERL_CROSS_DIR		:= $(BUILDDIR)/$(PERL)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(PERL_SOURCE):
	@$(call targetinfo)
	@$(call get, PERL)

$(PERL_CROSS_SOURCE):
	@$(call targetinfo)
	@$(call get, PERL_CROSS)

$(STATEDIR)/perl.get: $(PERL_CROSS_SOURCE)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

$(STATEDIR)/perl.extract:
	@$(call targetinfo)
	@$(call extract, PERL)
	@$(call extract, PERL_CROSS)
	@$(call patchin, PERL)
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

# Normally, --mode=cross should automatically do the two steps
# below, but it doesn't work for some reason.
PERL_HOST_CONF_OPT = \
	--mode=buildmini \
	--target=$(PTXCONF_GNU_TARGET) \
	--target-arch=$(PTXCONF_GNU_TARGET) \
	--set-target-name=$(PTXCONF_GNU_TARGET)

# We have to override LD, because an external multilib toolchain ld is not
# wrapped to provide the required sysroot options.  We also can't use ccache
# because the configure script doesn't support it.
PERL_CONF_OPT = \
	--mode=target \
	--target=$(PTXCONF_GNU_TARGET) \
	--target-tools-prefix=$(PTXCONF_COMPILER_PREFIX) \
	--prefix=/usr \
	-Dld="$(CROSS_CC)" \
	-A ccflags="$(CROSS_CPPFLAGS)" \
	-A ldflags="$(CROSS_LDFLAGS) -lm" \
	-A mydomain="" \
	-A myhostname="$(PTXCONF_ROOTFS_ETC_HOSTNAME)" \
	-A myuname="ptxdist $(PTXCONF_CONFIGFILE_VERSION)" \
	-A osname=linux \
	-A osvers=$(KERNEL_VERSION) \
	-A perlamdin=root


PERL_MODULES := constant Getopt/Std Time/Local

PERL_CONF_OPT += --only-mod=$(subst $(space),$(comma),$(PERL_MODULES))


$(STATEDIR)/perl.prepare:
	@$(call targetinfo)
	cd $(PERL_DIR) && \
		HOST_CC=$(HOSTCC) \
		./configure $(PERL_HOST_CONF_OPT)
	cd $(PERL_DIR) && \
		$(PERL_PATH) \
		./configure $(PERL_CONF_OPT)
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------
# 	#perlcross's miniperl_top forgets base, which is required by mktables.
#	#Instead of patching, it's easier to just set PERL5LIB

$(STATEDIR)/perl.compile:
	@$(call targetinfo)
	cd $(PERL_DIR) && \
		$(PERL_PATH) \
		PERL5LIB=$(PERL_DIR)/dist/base/lib $(MAKE) perl modules
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/perl.install:
	cd $(PERL_DIR) && \
		$(PERL_PATH) \
		PERL5LIB=$(PERL_DIR)/dist/base/lib $(MAKE) DESTDIR="$(PERL_PKGDIR)" install.perl
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/perl.targetinstall:
	@$(call targetinfo)

	@$(call install_init, perl)
	@$(call install_fixup, perl,PRIORITY,optional)
	@$(call install_fixup, perl,SECTION,base)
	@$(call install_fixup, perl,AUTHOR,"fabricega")
	@$(call install_fixup, perl,DESCRIPTION,missing)

	@$(call install_copy, perl, 0, 0, 0755, -, /usr/bin/perl)

	@cd $(PERL_PKGDIR)/usr/lib/perl && \
	find . -type f | while read file; do \
		$(call install_copy, perl, 0, 0, 644, \
		$(PERL_PKGDIR)/usr/lib/perl/$$file, \
			/usr/lib/perl/$$file); \
	done

	@$(call install_finish, perl)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/perl.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, PERL)

# vim: syntax=make
