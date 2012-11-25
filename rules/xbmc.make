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
PACKAGES-$(PTXCONF_XBMC) += xbmc

ifdef PTXCONF_XBMC
#ifeq ($(shell which ccache 2>/dev/null),)
#    $(warning *** ccache is mandatory to build xbmc)
#    $(warning *** please install ccache on HOST)
#    $(warning *** and set SETUP_CCACHE to 'y' in ptxdist setup -> Developer Options)
#    $(error )
#endif
ifeq ($(shell dpkg -l | grep libsdl-image | grep dev 2>/dev/null),)
    $(warning *** libsdl-image1.2-dev or above is mandatory to build xbmc)
    $(warning *** please install libsdl-image1.2-dev on HOST)
    $(error )
endif
ifdef PTXCONF_XBMC_GIT_SOURCE_MASTER
ifeq ($(shell which swig 2>/dev/null),)
    $(warning *** which is mandatory to build xbmc)
    $(warning *** please install which)
    $(error )
endif
endif
endif

#
# Paths and names
#
XBMC_VERSION	:= $(call remove_quotes,$(PTXCONF_XBMC_VERSION))
XBMC_MD5	:= $(call remove_quotes,$(PTXCONF_XBMC_MD5))
XBMC		:= xbmc-$(XBMC_VERSION)
XBMC_SUFFIX	:= zip
XBMC_URL	:= https://github.com/xbmc/xbmc/zipball/master
XBMC_SOURCE	:= $(SRCDIR)/$(XBMC).$(XBMC_SUFFIX)
XBMC_DIR	:= $(BUILDDIR)/$(XBMC)
XBMC_LICENSE	:= GPLv2

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(XBMC_SOURCE):
	@$(call targetinfo)
	@$(call get, XBMC)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------
XBMC_CFLAGS	:= $(CROSS_CFLAGS)
XBMC_CFLAGS	+= $(CROSS_CPPFLAGS)
XBMC_CFLAGS	+= -I$(SYSROOT)/include
XBMC_CFLAGS	+= -I$(SYSROOT)/usr/include
XBMC_CFLAGS	+= -I$(SYSROOT)/usr/include/interface/vcos

XBMC_ENV	:= $(CROSS_ENV) CFLAGS="$(XBMC_CFLAGS) -pipe -O3 -mcpu=arm1176jzf-s -mtune=arm1176jzf-s -mfloat-abi=hard -mfpu=vfp -mabi=aapcs-linux -Wno-psabi -Wa,-mno-warn-deprecated -Wno-deprecated-declarations -fomit-frame-pointer" CPPFLAGS="$(XBMC_CFLAGS)" CXXFLAGS="$(XBMC_CFLAGS)"
XBMC_PATH	:= PATH=$(CROSS_PATH):$(SYSROOT)/usr/bin
XBMC_TOOLCHAIN	:= $(PTXDIST_WORKSPACE)/selected_toolchain

#
# autoconf
#
XBMC_CONF_OPT	:= $(CROSS_AUTOCONF_USR) \
--disable-gl --enable-gles --disable-sdl --disable-x11 --disable-xrandr --disable-openmax \
--disable-optical-drive --disable-dvdcss --disable-joystick --enable-debug \
--disable-crystalhd --disable-vtbdecoder --disable-vaapi --disable-vdpau \
--disable-pulse --disable-projectm --enable-optimizations \
--enable-external-libraries --enable-external-ffmpeg --disable-goom --disable-hal \
--disable-airplay --disable-alsa --disable-libbluray --enable-mid --disable-nfs \
--disable-profiling --enable-rsxs --enable-rtmp --disable-vdadecoder

ifdef PTXCONF_RASPBERRY_PI
XBMC_CONF_OPT	+= --with-arch=arm
XBMC_CONF_OPT	+= --with-platform=raspberry-pi
XBMC_CONF_OPT	+= --enable-player=omxplayer
endif
#	--with-platform=raspberry-pi \
#	--disable-ccache \
#	--disable-gl \
#	--enable-gles \
#	--disable-x11 \
#	--disable-sdl \
#	--enable-optimizations \
#	--enable-external-libraries \
#	--disable-goom \
#	--disable-hal \
#	--disable-pulse \
#	--disable-vaapi \
#	--disable-vdpau \
#	--disable-xrandr \
#	--disable-airplay \
 #  	--disable-alsa \
#	--enable-avahi \
#	--disable-libbluray \
#	--disable-dvdcss \
 #  	--disable-debug \
#	--disable-joystick \
#	--enable-mid \
#	--disable-nfs \
#	--disable-profiling \
 #  	--disable-projectm \
#	--enable-rsxs \
#"	--enable-rtmp \
#	--disable-vaapi \
#	--disable-vdadecoder \
#	--disable-external-ffmpeg  \
#	--disable-optical-drive \
#	ac_cv_lib_bluetooth_hci_devid=no
#	MYSQL_CONFIG=$(SYSROOT)/usr/bin/mysql_config

$(STATEDIR)/xbmc.prepare:
	@$(call targetinfo)
	@$(call clean, $(XBMC_DIR)/config.cache)
	cd $(XBMC_DIR) && ./bootstrap
	cd $(XBMC_DIR) && \
		$(XBMC_PATH) $(XBMC_ENV) \
		./configure $(XBMC_CONF_OPT)
	cd $(XBMC_DIR) && \
		sed -i 's/-msse2//' lib/libsquish/Makefile
	cd $(XBMC_DIR) && \
		sed -i 's/-DSQUISH_USE_SSE=2//' lib/libsquish/Makefile
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/xbmc.compile:
	@$(call targetinfo)
	cd $(XBMC_DIR) && \
		$(XBMC_PATH) $(XBMC_ENV) \
		$(MAKE)
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/xbmc.targetinstall:
	@$(call targetinfo)

	@$(call install_init, xbmc)
	@$(call install_fixup, xbmc,PRIORITY,optional)
	@$(call install_fixup, xbmc,SECTION,base)
	@$(call install_fixup, xbmc,AUTHOR,"fga")
	@$(call install_fixup, xbmc,DESCRIPTION,missing)

	@$(call install_copy, xbmc, 0, 0, 0755, -, /usr/bin/xbmc)
	@$(call install_copy, xbmc, 0, 0, 0755, -, /usr/bin/xbmc-standalone)

	@cd $(XBMC_PKGDIR)/usr/lib/xbmc && \
	find . -type f | while read file; do \
		$(call install_copy, xbmc, 0, 0, 755, \
		$(XBMC_PKGDIR)/usr/lib/xbmc/$$file, \
			/usr/lib/xbmc/$$file); \
	done

	@cd $(XBMC_PKGDIR)/usr/share/icons && \
	find . -type f | while read file; do \
		$(call install_copy, xbmc, 0, 0, 644, \
		$(XBMC_PKGDIR)/usr/share/icons/$$file, \
			/usr/share/icons/$$file); \
	done

	@cd $(XBMC_PKGDIR)/usr/share/xbmc && \
	find . -type f | while read file; do \
		$(call install_copy, xbmc, 0, 0, 644, \
		$(XBMC_PKGDIR)/usr/share/xbmc/$$file, \
			/usr/share/xbmc/$$file); \
	done

ifdef PTXCONF_INITMETHOD_BBINIT
ifdef PTXCONF_XBMC_STARTSCRIPT
	@$(call install_alternative, xbmc, 0, 0, 0755, /etc/init.d/xbmc)

ifneq ($(call remove_quotes,$(PTXCONF_XBMC_BBINIT_STARTLINK)),)
	@$(call install_link, xbmc, \
		../init.d/xbmc, \
		/etc/rc.d/$(PTXCONF_XBMC_BBINIT_STARTLINK))
endif
ifneq ($(call remove_quotes,$(PTXCONF_XBMC_BBINIT_STOPLINK)),)
	@$(call install_link, xbmc, \
		../init.d/xbmc, \
		/etc/rc.d/$(PTXCONF_XBMC_BBINIT_STOPLINK))
endif
endif
endif

	@$(call install_finish, xbmc)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/xbmc.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, XBMC)

# vim: syntax=make
