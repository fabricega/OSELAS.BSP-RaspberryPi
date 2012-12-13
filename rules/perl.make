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

ifdef PTXCONF_PERL
colon := :
CROSS_PERL	:= $(PTXCONF_SYSROOT_HOST)/usr/bin/miniperl
CROSS_PERL_INCLIB := \
	$(SYSROOT)/usr/lib/perl \
	$(SYSROOT)/usr/lib/perl/$(PTXCONF_GNU_TARGET)
CROSS_PERL_PERL5LIB := $(subst $(space),$(colon),$(CROSS_PERL_INCLIB))
CROSS_PERL_OPTS := \
	$(CROSS_ENV) \
	PERL=$(CROSS_PERL) \
	PERL_LIB=$(SYSROOT)/usr/lib/perl \
	PERL_ARCHLIB=$(SYSROOT)/usr/lib/perl/$(PTXCONF_GNU_TARGET) \
	PERL_INC=$(SYSROOT)/usr/lib/perl/$(PTXCONF_GNU_TARGET)/CORE \
	INSTALLPRIVLIB=/usr/lib/perl \
	INSTALLARCHLIB=/usr/lib/perl/$(PTXCONF_GNU_TARGET) \
	INSTALLSITELIB=/usr/lib/perl \
	INSTALLVENDORLIB=/usr/lib/perl \
	INSTALLSITEARCH=/usr/lib/perl
endif
#	$(SYSROOT)/usr/lib/perl/cnf/cpan \
	$(SYSROOT)/usr/lib/perl/lib \
	$(SYSROOT)/usr/lib/perl/cpan/AutoLoader/lib \
	$(SYSROOT)/usr/lib/perl/dist/Cwd $(SYSROOT)/usr/lib/perl/dist/Cwd/lib \
	$(SYSROOT)/usr/lib/perl/dist/ExtUtils-Command/lib \
	$(SYSROOT)/usr/lib/perl/dist/ExtUtils-Install/lib \
	$(SYSROOT)/usr/lib/perl/cpan/ExtUtils-MakeMaker/lib \
	$(SYSROOT)/usr/lib/perl/dist/ExtUtils-Manifest/lib \
	$(SYSROOT)/usr/lib/perl/cpan/File-Path/lib \
	$(SYSROOT)/usr/lib/perl/ext/re \
	$(SYSROOT)/usr/lib/perl/cpan/ExtUtils-Constant/lib \
	$(SYSROOT)/usr/lib/perl/dist/ExtUtils-ParseXS/lib \
	$(SYSROOT)/usr/lib/perl/dist/constant/lib \
	$(SYSROOT)/usr/lib/perl/cpan/Getopt-Long/lib \
	$(SYSROOT)/usr/lib/perl/cpan/Text-Tabs/lib \
	$(SYSROOT)/usr/lib/perl/dist/Carp/lib

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
PERL_MODULES := $(call remove_quotes,$(PTXCONF_PERL_MODULES))


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
	-Dld="$(CROSS_LD)" \
	-A ccflags="$(CROSS_CPPFLAGS)" \
	-A ldflags="$(CROSS_LDFLAGS) -lm" \
	-A mydomain="" \
	-A myhostname="$(PTXCONF_ROOTFS_ETC_HOSTNAME)" \
	-A myuname="ptxdist $(PTXCONF_CONFIGFILE_VERSION)" \
	-A osname=linux \
	-A osvers=$(KERNEL_VERSION) \
	-A perlamdin=root

# Modules list to be included (none means all)
ifneq ($(call remove_quotes,$(PERL_MODULES)),)
# Add modules requested by other packages
ifneq ($(call remove_quotes,$(PERL_REQ_MODULES)),)
PERL_MODULES += $(call remove_quotes,$(PERL_REQ_MODULES))
endif
PERL_CONF_OPT += --only-mod=$(subst $(space),$(comma),$(PERL_MODULES))
endif

ifeq ($(shell expr $(PERL_VERSION_MINOR) % 2), 1)
PERL_CONF_OPT += -Dusedevel
endif

ifdef PTXCONF_GLOBAL_LARGE_FILE
PERL_CONF_OPT += -Uuselargefiles
endif

$(STATEDIR)/perl.prepare:
	@$(call targetinfo)
	cd $(PERL_DIR) && \
		HOST_CC=$(HOSTCC) \
		./configure $(PERL_HOST_CONF_OPT)
	cd $(PERL_DIR) && \
		$(PERL_PATH) \
		./configure $(PERL_CONF_OPT)
	cd $(PERL_DIR) && \
		$(PERL_PATH) \
		sed -i 's/UNKNOWN-/ptxdist-$(call remove_quotes,$(PTXCONF_CONFIGFILE_VERSION)) /' patchlevel.h
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
	@$(call targetinfo)
	cd $(PERL_DIR) && \
		$(PERL_PATH) \
		PERL5LIB=$(PERL_DIR)/dist/base/lib $(MAKE) DESTDIR="$(PERL_PKGDIR)" install.perl
	cd $(PERL_DIR) && \
		$(PERL_PATH) \
		PERL5LIB=$(PERL_DIR)/dist/base/lib $(MAKE) DESTDIR="$(PTXCONF_SYSROOT_HOST)" install.miniperl
	@$(call touch)

$(STATEDIR)/perl.install.post:
	@$(call targetinfo)
	@$(call world/install.post, PERL)
	@sed -i 's,/usr,$(call remove_quotes,$(SYSROOT))/usr,g' $(SYSROOT)/usr/lib/perl/$(PTXCONF_GNU_TARGET)/Config.pm
#	sed -i "s,[\']/usr,\'$(call remove_quotes,$(SYSROOT))/usr,g" $(SYSROOT)/usr/lib/perl/$(PTXCONF_GNU_TARGET)/Config_heavy.pl
#	@sed -i 's,/usr,$(call remove_quotes,$(SYSROOT))/usr,g' $(PTXCONF_SYSROOT_HOST)/usr/lib/perl/Config.pm
#	sed -i "s,[\']/usr,\'$(call remove_quotes,$(SYSROOT))/usr,g" $(PTXCONF_SYSROOT_HOST)/usr/lib/perl/Config_heavy.pl

##	@sed -i 's,/usr/lib/perl/$(call remove_quotes,$(PTXCONF_GNU_TARGET)),$(call remove_quotes,$(SYSROOT)/usr/lib/perl/$(PTXCONF_GNU_TARGET)),g' $(SYSROOT)/usr/lib/perl/$(PTXCONF_GNU_TARGET)/Config.pm
	@sed -i 's,/usr/lib/perl/$(call remove_quotes,$(PTXCONF_GNU_TARGET)),$(call remove_quotes,$(SYSROOT)/usr/lib/perl/$(PTXCONF_GNU_TARGET)),g' $(SYSROOT)/usr/lib/perl/$(PTXCONF_GNU_TARGET)/Config_heavy.pl
##	sed -i "s,[privlib.*=\'/usr/lib/perl\'],[privlib.*=\'$(call remove_quotes,$(SYSROOT)/usr/lib/perl)/usr/lib/perl\'],g" $(SYSROOT)/usr/lib/perl/$(PTXCONF_GNU_TARGET)/Config_heavy.pl
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
#
	@$(call install_copy, perl, 0, 0, 0755, -, /usr/bin/perl)
#	@$(call install_copy, perl, 0, 0, 0755, -, /usr/bin/perl5.16.1)
#
#	@cd $(PERL_PKGDIR)/usr/lib/perl && \
#	find . -type f | while read file; do \
#		$(call install_copy, perl, 0, 0, 644, \
#		$(PERL_PKGDIR)/usr/lib/perl/$$file, \
#			/usr/lib/perl/$$file); \
#	done
#
	@$(call install_finish, perl)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/perl.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, PERL)

# vim: syntax=make
