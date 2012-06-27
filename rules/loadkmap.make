# -*-makefile-*-
#
# Copyright (C) 2012 by fga
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_LOADKMAP) += loadkmap

#
# Paths and names
#
LOADKMAP_VERSION	:= 1.0
LOADKMAP_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# omit get
# ----------------------------------------------------------------------------

$(STATEDIR)/loadkmap.get:
		@$(call targetinfo)
		@$(call touch)

# ----------------------------------------------------------------------------
# omit extract
# ----------------------------------------------------------------------------

$(STATEDIR)/loadkmap.extract:
		@$(call targetinfo)
		@$(call touch)

# ----------------------------------------------------------------------------
# omit prepare
# ----------------------------------------------------------------------------
$(STATEDIR)/loadkmap.prepare:
		@$(call targetinfo)
		@$(call touch)

# ----------------------------------------------------------------------------
# omit compile
# ----------------------------------------------------------------------------

$(STATEDIR)/loadkmap.compile:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# omit install
# ----------------------------------------------------------------------------

$(STATEDIR)/loadkmap.install:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/loadkmap.targetinstall:
	@$(call targetinfo)

	@$(call install_init, loadkmap)
	@$(call install_fixup, loadkmap,PRIORITY,optional)
	@$(call install_fixup, loadkmap,SECTION,base)
	@$(call install_fixup, loadkmap,AUTHOR,"fga")
	@$(call install_fixup, loadkmap,DESCRIPTION,missing)

ifdef PTXCONF_INITMETHOD_BBINIT
ifdef PTXCONF_LOADKMAP_STARTSCRIPT
	@$(call install_alternative, loadkmap, 0, 0, 0755, /etc/init.d/loadkmap)

# keyboard kmap file
ifneq ($(call remove_quotes,$(PTXCONF_LOADKMAP_FILE)),)
	@$(call install_alternative, loadkmap, 0, 0, 0644, $(PTXCONF_LOADKMAP_FILE))

	@$(call install_replace, loadkmap, /etc/init.d/loadkmap, @KMAP@, \
		$(call remove_quotes,$(PTXCONF_LOADKMAP_FILE)))

endif

# startup link
ifneq ($(call remove_quotes,$(PTXCONF_LOADKMAP_BBINIT_STARTLINK)),)
	@$(call install_link, loadkmap, \
		../init.d/loadkmap, \
		/etc/rc.d/$(PTXCONF_LOADKMAP_BBINIT_STARTLINK))
endif

endif
endif



	@$(call install_finish, loadkmap)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/loadkmap.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, LOADKMAP)

# vim: syntax=make
