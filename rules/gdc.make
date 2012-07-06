# -*-makefile-*-
#
# Copyright (C) 2012 by alexandre coffignal <alexandre.github@gmail.com>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_GDC) += gdc-src

#
# Paths and names
#
GDC_VERSION	:= 1.0
GDC_LICENSE	:= GPL



# ----------------------------------------------------------------------------
# omit the 'get' stage (due to the fact, the files are already present)
# ----------------------------------------------------------------------------
$(STATEDIR)/gdc-src.get:
		@$(call targetinfo)
		@$(call touch)

# ----------------------------------------------------------------------------
# omit the 'extract' stage (due to the fact, all files are already present)
# ----------------------------------------------------------------------------
$(STATEDIR)/gdc-src.extract:
		@$(call targetinfo)
		@$(call touch)

# ----------------------------------------------------------------------------
# omit the 'prepare' stage (due to the fact, nothing is to be built)
# ----------------------------------------------------------------------------
$(STATEDIR)/gdc-src.prepare:
		@$(call targetinfo)
		@$(call touch)

# ----------------------------------------------------------------------------
# omit the 'compile' stage (due to the fact, nothing is to be built)
# ----------------------------------------------------------------------------
$(STATEDIR)/gdc-src.compile:
		@$(call targetinfo)
		@$(call touch)

# ----------------------------------------------------------------------------
# omit the 'install' stage (due to the fact, nothing is to be installed into the sysroot)
# ----------------------------------------------------------------------------
$(STATEDIR)/gdc-src.install:
		@$(call targetinfo)
		@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/gdc-src.targetinstall:
	@$(call targetinfo)

	@$(call install_init,  gdc-src)
	@$(call install_fixup, gdc-src,PACKAGE,gdc-src)
	@$(call install_fixup, gdc-src,PRIORITY,optional)
	@$(call install_fixup, gdc-src,VERSION,$(GDC_VERSION))
	@$(call install_fixup, gdc-src,SECTION,base)
	@$(call install_fixup, gdc-src,AUTHOR,"Alexandre Coffignal <alexandre.github@gmail.com>")
	@$(call install_fixup, gdc-src,DEPENDS,)
	@$(call install_fixup, gdc-src,DESCRIPTION,missing)
	@$(call install_archive, gdc-src, 0, 0, $(PTXDIST_WORKSPACE)/local_src/gdc-1.0/gdc-1.0.tgz,)

	@$(call install_finish, gdc-src)

	@$(call touch)

# vim: syntax=make

