# -*-makefile-*-
#
# Copyright (C) 2006, 2009, 2010 by Marc Kleine-Budde <mkl@pengutronix.de>
#               2010 by Erwin Rol <erwin@erwinrol.com>
#               2012 by fabricega
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_DIRECTFB) += directfb

#
# Paths and names
#
ifdef PTXCONF_DIRECTFB_VERSION_1_7_GIT
DIRECTFB_VERSION	:= 1.7-git
DIRECTFB_LIBVER		:= 1.7
DIRECTFB_REV		:= bcba03c5cf4bf6443c2ff8787c0b95c445375c53
DIRECTFB		:= directfb-$(DIRECTFB_VERSION)
DIRECTFB_GIT		:= git://git.directfb.org/git/directfb/core/DirectFB.git
DIRECTFB_DIR		:= $(BUILDDIR)/$(DIRECTFB)
DIRECTFB_LICENSE	:= unknown
else
ifdef PTXCONF_DIRECTFB_VERSION_1_6_2
DIRECTFB_VERSION	:= 1.6.2
DIRECTFB_LIBVER		:= 1.6
DIRECTFB_MD5		:= 6bebdbf26f03f7114ae17ab86d4d1d27
DIRECTFB		:= DirectFB-$(DIRECTFB_VERSION)
DIRECTFB_SUFFIX		:= tar.gz
DIRECTFB_SOURCE		:= $(SRCDIR)/$(DIRECTFB).$(DIRECTFB_SUFFIX)
DIRECTFB_DIR		:= $(BUILDDIR)/$(DIRECTFB)
DIRECTFB_URL		:= http://directfb.org/downloads/Core/DirectFB-1.6/$(DIRECTFB).$(DIRECTFB_SUFFIX)
else
DIRECTFB_VERSION	:= 1.4.3
DIRECTFB_LIBVER		:= 1.4
DIRECTFB_MD5		:= 223e036da906ceb4bd44708026839ff1
DIRECTFB		:= DirectFB-$(DIRECTFB_VERSION)
DIRECTFB_SUFFIX		:= tar.gz
DIRECTFB_SOURCE		:= $(SRCDIR)/$(DIRECTFB).$(DIRECTFB_SUFFIX)
DIRECTFB_DIR		:= $(BUILDDIR)/$(DIRECTFB)

DIRECTFB_URL		:= \
	http://www.directfb.org/downloads/Core/DirectFB-1.4/$(DIRECTFB).$(DIRECTFB_SUFFIX) \
	http://www.directfb.org/downloads/Old/$(DIRECTFB).$(DIRECTFB_SUFFIX)
endif
endif

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

ifdef PTXCONF_DIRECTFB_VERSION_1_7_GIT
$(STATEDIR)/directfb.get:
	@$(call targetinfo)
	if [ -d $(DIRECTFB_DIR) ]; then rm -rf $(DIRECTFB_DIR); fi;
ifdef PTXCONF_DIRECTFB_VERSION_1_7_GIT_HEAD
	mkdir -p $(DIRECTFB_DIR) && \
		cd $(DIRECTFB_DIR) && \
		git clone --depth 1 $(DIRECTFB_GIT) .
else
	mkdir -p $(DIRECTFB_DIR) && \
		cd $(DIRECTFB_DIR) && \
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
$(STATEDIR)/directfb.extract:
	@$(call targetinfo)
	if [ -e $(DIRECTFB_DIR)/patches ]; then \
		cd $(DIRECTFB_DIR) && mv patches patches.orig; \
	fi;
	cd $(DIRECTFB_DIR) && \
		ln -s $(PTXDIST_WORKSPACE)/patches/$(DIRECTFB) patches && \
		quilt push -a
	cd $(DIRECTFB_DIR) && \
		mv patches patches.quilt && mv patches.orig patches
	@$(call touch)
endif

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#DIRECTFB_CONF_ENV	:= $(CROSS_ENV)
DIRECTFB_MAKE_OPT	:= CFLAGS="$(CROSS_CPPFLAGS)" LDFLAGS="$(CROSS_LDFLAGS)" $(CROSS_ENV) CROSS_COMPILE_PREFIX=$(SYSROOT)

#
# autoconf
#
DIRECTFB_INPUT-$(PTXCONF_DIRECTFB_INPUT_KEYBOARD)	+= keyboard
DIRECTFB_INPUT-$(PTXCONF_DIRECTFB_INPUT_LINUXINPUT)	+= linuxinput
DIRECTFB_INPUT-$(PTXCONF_DIRECTFB_INPUT_PS2MOUSE)	+= ps2mouse
DIRECTFB_INPUT-$(PTXCONF_DIRECTFB_INPUT_TSLIB)		+= tslib


DIRECTFB_GFX-$(PTXCONF_DIRECTFB_GFX_ATI128)		+= ati128
DIRECTFB_GFX-$(PTXCONF_DIRECTFB_GFX_CLE266)		+= cle266
DIRECTFB_GFX-$(PTXCONF_DIRECTFB_GFX_CYBER5K)		+= cyber5k
DIRECTFB_GFX-$(PTXCONF_DIRECTFB_GFX_DAVINCI)		+= davinci
DIRECTFB_GFX-$(PTXCONF_DIRECTFB_GFX_EP9X)		+= ep9x
DIRECTFB_GFX-$(PTXCONF_DIRECTFB_GFX_GL)			+= gl
DIRECTFB_GFX-$(PTXCONF_DIRECTFB_GFX_I810)		+= i810
DIRECTFB_GFX-$(PTXCONF_DIRECTFB_GFX_I830)		+= i830
DIRECTFB_GFX-$(PTXCONF_DIRECTFB_GFX_MACH64)		+= mach64
DIRECTFB_GFX-$(PTXCONF_DIRECTFB_GFX_MATROX)		+= matrox
DIRECTFB_GFX-$(PTXCONF_DIRECTFB_GFX_NEOMAGIC)		+= neomagic
DIRECTFB_GFX-$(PTXCONF_DIRECTFB_GFX_NSC)		+= nsc
DIRECTFB_GFX-$(PTXCONF_DIRECTFB_GFX_NVIDIA)		+= nvidia
DIRECTFB_GFX-$(PTXCONF_DIRECTFB_GFX_OMAP)		+= omap
DIRECTFB_GFX-$(PTXCONF_DIRECTFB_GFX_RADEON)		+= radeon
DIRECTFB_GFX-$(PTXCONF_DIRECTFB_GFX_SAVAGE)		+= savage
DIRECTFB_GFX-$(PTXCONF_DIRECTFB_GFX_SIS315)		+= sis315
DIRECTFB_GFX-$(PTXCONF_DIRECTFB_GFX_TDFX)		+= tdfx
DIRECTFB_GFX-$(PTXCONF_DIRECTFB_GFX_UNICHROME)		+= unichrome
DIRECTFB_GFX-$(PTXCONF_DIRECTFB_GFX_VMWARE)		+= vmware
DIRECTFB_GFX-$(PTXCONF_DIRECTFB_GFX_GLES2)		+= gles2

#
# autoconf
#
DIRECTFB_AUTOCONF := \
	$(CROSS_AUTOCONF_USR) \
	--without-tests \
	--with-tools \
	--disable-osx \
	--disable-network \
	--disable-voodoo \
	--disable-sdl \
	--disable-vnc \
	--disable-mmx \
	--disable-sse \
	--with-gfxdrivers=$(subst $(space),$(comma),$(DIRECTFB_GFX-y)) \
	--with-inputdrivers=$(subst $(space),$(comma),$(DIRECTFB_INPUT-y))

ifdef PTXCONF_DIRECTFB_GFX_GLES2
DIRECTFB_AUTOCONF += \
	--enable-egl \
	EGL_CFLAGS='-I$(SYSROOT)/usr/include -I$(SYSROOT)/usr/include/interface/vcos/pthreads' \
	EGL_LIBS='-L$(SYSROOT)/usr/lib -lGLESv2 -lEGL'
endif

ifdef PTXCONF_DIRECTFB_LINUX_FUSION
DIRECTFB_AUTOCONF += ac_cv_header_linux_fusion_h=yes
else
DIRECTFB_AUTOCONF += ac_cv_header_linux_fusion_h=no
endif

ifdef PTXCONF_DIRECTFB_BUILD_MULTI
DIRECTFB_AUTOCONF += --enable-multi
else
DIRECTFB_AUTOCONF += --disable-multi
endif

ifdef PTXCONF_DIRECTFB_VERSION_1_7_GIT
DIRECTFB_AUTOCONF += --disable-fusiondale
DIRECTFB_AUTOCONF += --disable-fusionsound
endif

ifdef PTXCONF_DIRECTFB_X11
DIRECTFB_AUTOCONF += --enable-x11
else
DIRECTFB_AUTOCONF += --disable-x11
endif

ifdef PTXCONF_DIRECTFB_FBDEV
DIRECTFB_AUTOCONF += --enable-fbdev
else
DIRECTFB_AUTOCONF += --disable-fbdev
endif

ifdef PTXCONF_DIRECTFB_V4L
DIRECTFB_AUTOCONF += --enable-video4linux
else
DIRECTFB_AUTOCONF += --disable-video4linux
endif

ifdef PTXCONF_DIRECTFB_V4L2
DIRECTFB_AUTOCONF += --enable-video4linux2
else
DIRECTFB_AUTOCONF += --disable-video4linux2
endif

ifdef PTXCONF_DIRECTFB_DEBUG
DIRECTFB_AUTOCONF += --enable-debug-support
DIRECTFB_MODULE_DIRECTORY := /usr/lib/directfb-$(DIRECTFB_LIBVER)-0
else
DIRECTFB_AUTOCONF += --disable-debug-support
DIRECTFB_MODULE_DIRECTORY := /usr/lib/directfb-$(DIRECTFB_LIBVER)-0-pure
endif

ifdef PTXCONF_DIRECTFB_TRACE
DIRECTFB_AUTOCONF += --enable-trace
else
DIRECTFB_AUTOCONF += --disable-trace
endif

ifdef PTXCONF_DIRECTFB_WM_UNIQUE
DIRECTFB_AUTOCONF += --enable-unique
else
DIRECTFB_AUTOCONF += --disable-unique
endif

ifdef PTXCONF_DIRECTFB_ZLIB
DIRECTFB_AUTOCONF += --enable-zlib
else
DIRECTFB_AUTOCONF += --disable-zlib
endif

ifdef PTXCONF_DIRECTFB_IMAGE_GIF
DIRECTFB_AUTOCONF += --enable-gif
else
DIRECTFB_AUTOCONF += --disable-gif
endif

ifdef PTXCONF_DIRECTFB_IMAGE_PNG
DIRECTFB_AUTOCONF += --enable-png
else
DIRECTFB_AUTOCONF += --disable-png
endif

ifdef PTXCONF_DIRECTFB_IMAGE_JPEG
DIRECTFB_AUTOCONF += --enable-jpeg
else
DIRECTFB_AUTOCONF += --disable-jpeg
endif

ifdef PTXCONF_DIRECTFB_FONT_FREETYPE
DIRECTFB_AUTOCONF += --enable-freetype
else
DIRECTFB_AUTOCONF += --disable-freetype
endif

ifdef PTXCONF_DIRECTFB_VERSION_1_7_GIT
$(STATEDIR)/directfb.prepare:
	@$(call targetinfo)
	@$(call clean, $(DIRECTFB_DIR)/config.cache)
	cd $(DIRECTFB_DIR) && \
		$(DIRECTFB_PATH) $(DIRECTFB_ENV) \
		./autogen.sh $(DIRECTFB_AUTOCONF)
	@$(call touch)
endif

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/directfb.targetinstall:
	@$(call targetinfo)

	@$(call install_init, directfb)
	@$(call install_fixup, directfb,PRIORITY,optional)
	@$(call install_fixup, directfb,SECTION,base)
	@$(call install_fixup, directfb,AUTHOR,"fga")
	@$(call install_fixup, directfb,DESCRIPTION,missing)

ifdef PTXCONF_DIRECTFB_CONFIG_DIRECTFBRC
	@$(call install_alternative, directfb, 0, 0, 0644, /etc/directfbrc)
endif

ifdef PTXCONF_PRELINK
	@$(call install_alternative, directfb, 0, 0, 0644, \
		/etc/prelink.conf.d/directfb)
endif

	@$(call install_copy, directfb, 0, 0, 0755, -, /usr/bin/dfbinfo)

	@$(call install_lib, directfb, 0, 0, 0644, libdirectfb-$(DIRECTFB_LIBVER))
	@$(call install_lib, directfb, 0, 0, 0644, libfusion-$(DIRECTFB_LIBVER))
	@$(call install_lib, directfb, 0, 0, 0644, libdirect-$(DIRECTFB_LIBVER))

ifdef PTXCONF_DIRECTFB_WM_UNIQUE
	@$(call install_lib, directfb, 0, 0, 0644, libuniquewm-$(DIRECTFB_LIBVER))
endif

	@cd $(DIRECTFB_PKGDIR) && for plugin in `find ./$(DIRECTFB_MODULE_DIRECTORY) -name "*.so"`; do \
		$(call install_copy, directfb, 0, 0, 0644, -, /$$plugin); \
	done

	@$(call install_finish, directfb)

	@$(call touch)

# vim: syntax=make

