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
PACKAGES-$(PTXCONF_TTF_DEJAVU) += ttf-dejavu

#
# Paths and names
#
TTF_DEJAVU_VERSION	:= 2.33
TTF_DEJAVU_MD5		:= 8b601e91725b6d69141b0fcf527948c0
TTF_DEJAVU		:= ttf-dejavu-$(TTF_DEJAVU_VERSION)
TTF_DEJAVU_SUFFIX	:= tar.bz2
TTF_DEJAVU_URL		:= http://sourceforge.net/projects/dejavu/files/dejavu/$(TTF_DEJAVU_VERSION)/dejavu-fonts-ttf-$(TTF_DEJAVU_VERSION).$(TTF_DEJAVU_SUFFIX)
TTF_DEJAVU_SOURCE	:= $(SRCDIR)/$(TTF_DEJAVU).$(TTF_DEJAVU_SUFFIX)
TTF_DEJAVU_DIR		:= $(BUILDDIR)/$(TTF_DEJAVU)
TTF_DEJAVU_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/ttf-dejavu.compile:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/ttf-dejavu.install:
	@$(call targetinfo)
	mkdir -p $(SYSROOT)/usr/share/fonts/truetype/ttf-dejavu
	mkdir -p $(TTF_DEJAVU_PKGDIR)/usr/share/fonts/truetype/ttf-dejavu
	cp -a $(TTF_DEJAVU_DIR)/ttf/*.ttf $(SYSROOT)/usr/share/fonts/truetype/ttf-dejavu
	cp -a $(TTF_DEJAVU_DIR)/ttf/*.ttf $(TTF_DEJAVU_PKGDIR)/usr/share/fonts/truetype/ttf-dejavu
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/ttf-dejavu.targetinstall:
	@$(call targetinfo)

	@$(call install_init, ttf-dejavu)
	@$(call install_fixup, ttf-dejavu,PRIORITY,optional)
	@$(call install_fixup, ttf-dejavu,SECTION,base)
	@$(call install_fixup, ttf-dejavu,AUTHOR,"fabricega")
	@$(call install_fixup, ttf-dejavu,DESCRIPTION,missing)

	@cd $(TTF_DEJAVU_PKGDIR)/usr/share/fonts/truetype/ttf-dejavu && \
	find . -type f | while read file; do \
		$(call install_copy, ttf-dejavu, 0, 0, 644, \
		$(TTF_DEJAVU_PKGDIR)/usr/share/fonts/truetype/ttf-dejavu/$$file, \
			/usr/share/fonts/truetype/ttf-dejavu/$$file, n); \
	done

	@$(call install_finish, ttf-dejavu)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/ttf-dejavu.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, TTF_DEJAVU)

# vim: syntax=make
