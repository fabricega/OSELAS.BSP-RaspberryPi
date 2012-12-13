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
HOST_PACKAGES-$(PTXCONF_HOST_PERL) += host-perl

#
# Paths and names
#
HOST_PERL_DIR	=  $(HOST_BUILDDIR)/$(PERL)

ifdef PTXCONF_PERL
colon := :
PERL_HOST	:= $(PTXCONF_SYSROOT_HOST)/usr/bin/perl
PERL_HOST_INCLIB := \
	$(PTXCONF_SYSROOT_HOST)/usr/lib/perl \
	$(PTXCONF_SYSROOT_HOST)/usr/lib/perl/$(PTXCONF_GNU_TARGET)
PERL_HOST_PERL5LIB := $(subst $(space),$(colon),$(PERL_HOST_INCLIB))
PERL_HOST_OPTS := \
	$(HOST_ENV) \
	PERL=$(PERL_HOST) \
	PERL_LIB=$(PTXCONF_SYSROOT_HOST)/usr/lib/perl \
	PERL_ARCHLIB=$(PTXCONF_SYSROOT_HOST)/usr/lib/perl/$(PTXCONF_GNU_TARGET) \
	PERL_INC=$(PTXCONF_SYSROOT_HOST)/usr/lib/perl/$(PTXCONF_GNU_TARGET)/CORE \
	INSTALLPRIVLIB=/usr/lib/perl \
	INSTALLARCHLIB=/usr/lib/perl/$(PTXCONF_GNU_TARGET) \
	INSTALLSITELIB=/usr/lib/perl \
	INSTALLVENDORLIB=/usr/lib/perl \
	INSTALLSITEARCH=/usr/lib/perl
endif


# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

$(STATEDIR)/host-perl.extract:
	@$(call targetinfo)
	@$(call clean, $(HOST_PERL_DIR))
	tar -C $(HOST_BUILDDIR) -xzf $(PERL_SOURCE)
	tar -C $(HOST_PERL_DIR) --strip-components=1 -xzf $(PERL_CROSS_SOURCE)
	@$(call patchin, PERL, $(HOST_PERL_DIR))
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

ifneq ( "a",)
#HOST_PERL_CONF_ENV	:= $(HOST_ENV)
HOST_PERL_MODULES := $(call remove_quotes,$(PTXCONF_PERL_MODULES))

# Normally, --mode=cross should automatically do the two steps
# below, but it doesn't work for some reason.
HOST_PERL_HOST_CONF_OPT = \
	--mode=buildmini \
	--target=$(PTXCONF_GNU_TARGET) \
	--target-arch=$(PTXCONF_GNU_TARGET) \
	--set-target-name=$(PTXCONF_GNU_TARGET)

# We have to override LD, because an external multilib toolchain ld is not
# wrapped to provide the required sysroot options.  We also can't use ccache
# because the configure script doesn't support it.
HOST_PERL_CONF_OPT = \
	--mode=native \
	--target=$(PTXCONF_GNU_TARGET) \
	--target-arch=$(PTXCONF_GNU_TARGET) \
	--set-target-name=$(PTXCONF_GNU_TARGET) \
	--prefix=/usr \
	-Dld="$(HOST_CC)" \
	-A ccflags="$(HOST_CPPFLAGS) $(HOST_CFLAGS)" \
	-A ldflags="$(HOST_LDFLAGS) -lm" \
	-A mydomain="" \
	-A myhostname="$(shell hostname)" \
	-A myuname="ptxdist $(PTXCONF_CONFIGFILE_VERSION)" \
	-A osname=linux \
	-A osvers="$(shell uname -r)" \
	-A perlamdin="$(shell echo $USER)"

ifneq ($(call remove_quotes,$(HOST_PERL_MODULES)),)
HOST_PERL_CONF_OPT += --only-mod=$(subst $(space),$(comma),$(HOST_PERL_MODULES))
endif

ifeq ($(shell expr $(PERL_VERSION_MINOR) % 2), 1)
HOST_PERL_CONF_OPT += -Dusedevel
endif

ifdef PTXCONF_GLOBAL_LARGE_FILE
HOST_PERL_CONF_OPT += -Uuselargefiles
endif

$(STATEDIR)/host-perl.prepare:
	@$(call targetinfo)
#	cd $(HOST_PERL_DIR) && \
#		HOST_CC=$(HOSTCC) \
#		./configure $(HOST_PERL_HOST_CONF_OPT)
	cd $(HOST_PERL_DIR) && \
		$(HOST_PERL_PATH) \
		./configure $(HOST_PERL_CONF_OPT)
	cd $(HOST_PERL_DIR) && \
		$(HOST_PERL_PATH) \
		sed -i 's/UNKNOWN-/ptxdist-$(call remove_quotes,$(PTXCONF_CONFIGFILE_VERSION)) /' patchlevel.h
	@$(call touch)
else
$(STATEDIR)/host-perl.prepare:
	@$(call targetinfo)
	cd $(HOST_PERL_DIR) && \
		$(HOST_PERL_PATH) $(HOST_PERL_ENV) \
		./Configure -des -Dprefix=$(PTXCONF_SYSROOT_HOST)
	@$(call touch)

endif
#
# autoconf
#
#HOST_PERL_CONF_TOOL	:= autoconf
#HOST_PERL_CONF_OPT	:= $(HOST_AUTOCONF)

#$(STATEDIR)/host-perl.prepare:
#	@$(call targetinfo)
#	@$(call clean, $(HOST_PERL_DIR)/config.cache)
#	cd $(HOST_PERL_DIR) && \
#		$(HOST_PERL_PATH) $(HOST_PERL_ENV) \
#		./configure $(HOST_PERL_CONF_OPT)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------
# 	#perlcross's miniperl_top forgets base, which is required by mktables.
#	#Instead of patching, it's easier to just set PERL5LIB

$(STATEDIR)/host-perl.compile:
	@$(call targetinfo)
	cd $(HOST_PERL_DIR) && \
		$(HOST_PERL_PATH) \
		PERL5LIB=$(HOST_PERL_DIR)/dist/base/lib $(MAKE) perl modules
	@$(call touch)


# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/host-perl.install:
	@$(call targetinfo)
	cd $(HOST_PERL_DIR) && \
		$(HOST_PERL_PATH) \
		PERL5LIB=$(HOST_PERL_DIR)/dist/base/lib $(MAKE) DESTDIR="$(HOST_PERL_PKGDIR)" install.perl
	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/host-perl.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, HOST_PERL)

# vim: syntax=make
