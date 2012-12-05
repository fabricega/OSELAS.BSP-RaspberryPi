# -*-makefile-*-
#
# Copyright (C) 2007 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_DIRECTFB) += host-directfb

#
# Paths and names
#
HOST_DIRECTFB_DIR	= $(HOST_BUILDDIR)/$(DIRECTFB)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

ifdef PTXCONF_DIRECTFB_VERSION_1_7_GIT
$(STATEDIR)/host-directfb.get:
	@$(call targetinfo)
	if [ -d $(HOST_DIRECTFB_DIR) ]; then rm -rf $(HOST_DIRECTFB_DIR); fi;
ifdef PTXCONF_DIRECTFB_VERSION_1_7_GIT_HEAD
	mkdir -p $(HOST_DIRECTFB_DIR) && \
		cd $(HOST_DIRECTFB_DIR) && \
		git clone --depth 1 $(DIRECTFB_GIT) .
else
	mkdir -p $(HOST_DIRECTFB_DIR) && \
		cd $(HOST_DIRECTFB_DIR) && \
		git clone $(DIRECTFB_GIT) . && \
		git checkout $(DIRECTFB_REV)
endif
	@$(call touch)
else
$(DIRECTFB_SOURCE):
	@$(call targetinfo)
	@$(call get, DIRECTFB)
endif


# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

ifdef PTXCONF_DIRECTFB_VERSION_1_7_GIT
$(STATEDIR)/host-directfb.extract:
	@$(call targetinfo)
	if [ -e $(HOST_DIRECTFB_DIR)/patches ]; then \
		cd $(HOST_DIRECTFB_DIR) && mv patches patches.orig; \
	fi;
	cd $(HOST_DIRECTFB_DIR) && \
		ln -s $(PTXDIST_WORKSPACE)/patches/$(DIRECTFB) patches && \
		quilt push -a
	cd $(HOST_DIRECTFB_DIR) && \
		mv patches patches.quilt && mv patches.orig patches
	@$(call touch)
endif

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

HOST_DIRECTFB_PATH	:= PATH=$(HOST_PATH)
HOST_DIRECTFB_ENV 	:= $(HOST_ENV)

#
# autoconf
#
HOST_DIRECTFB_AUTOCONF	:= \
	$(HOST_AUTOCONF) \
	--disable-osx \
	--disable-x11 \
	--disable-network \
	--disable-multi \
	--disable-voodoo \
	--disable-unique \
	--disable-fbdev \
	--disable-sdl \
	--disable-vnc \
	--disable-sysfs \
	--disable-jpeg \
	--disable-zlib \
	--disable-gif \
	--disable-freetype \
	--disable-video4linux \
	--disable-video4linux2 \
	\
	--with-gfxdrivers=none \
	--with-inputdrivers=none \
	\
	--enable-png

ifdef PTXCONF_DIRECTFB_VERSION_1_7_GIT
$(STATEDIR)/host-directfb.prepare:
	@$(call targetinfo)
	@$(call clean, $(HOST_DIRECTFB_DIR)/config.cache)
	cd $(HOST_DIRECTFB_DIR) && \
		$(HOST_DIRECTFB_PATH) $(HOST_DIRECTFB_ENV) \
		./autogen.sh $(HOST_DIRECTFB_AUTOCONF)
	@$(call touch)
endif

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/host-directfb.compile:
	@$(call targetinfo)
	cd $(HOST_DIRECTFB_DIR)/tools && $(HOST_DIRECTFB_PATH) $(MAKE) $(PARALLELMFLAGS) directfb-csource
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/host-directfb.install:
	@$(call targetinfo)
	install -D -m 755 $(HOST_DIRECTFB_DIR)/tools/directfb-csource $(HOST_DIRECTFB_PKGDIR)/bin/directfb-csource
	@$(call touch)

# vim: syntax=make
