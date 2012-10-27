# -*-makefile-*-
#
# Copyright (C) 2006 by Erwin Rol
#           (C) 2010 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#
#
#
# We provide this package
#
PACKAGES-$(PTXCONF_FFMPEG) += ffmpeg

#
# Paths and names
#
#FFMPEG_VERSION	:= r12314
#FFMPEG_MD5	:= 133d37ddc2a0bca3dc920a893bc96dc3
#FFMPEG_VERSION	:= 0.11
#FFMPEG_MD5	:= 101e1092582bbfca8f2a204cbcecb8fc
FFMPEG_VERSION	:= 0.10.2
FFMPEG_MD5	:= de1bd5fc4bbf3ef730a5361ee596fedd
FFMPEG		:= ffmpeg-$(FFMPEG_VERSION)
FFMPEG_SUFFIX	:= tar.bz2
FFMPEG_URL	:= http://www.pengutronix.de/software/ptxdist/temporary-src/$(FFMPEG).$(FFMPEG_SUFFIX) \
		   http://www.ffmpeg.org/releases/$(FFMPEG).$(FFMPEG_SUFFIX)
FFMPEG_SOURCE	:= $(SRCDIR)/$(FFMPEG).$(FFMPEG_SUFFIX)
FFMPEG_DIR	:= $(BUILDDIR)/$(FFMPEG)


# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(FFMPEG_SOURCE):
	@$(call targetinfo)
	@$(call get, FFMPEG)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

FFMPEG_PATH	:= PATH=$(CROSS_PATH)
FFMPEG_ENV 	:= $(CROSS_ENV)

#
# autoconf
# Carefull, ffmpeg has a home grown configure, and not all autoconf options work!!! :-/
# for example it enables things by default and than only has a --disable-BLA option and no
# --enable-BLA option.
#
FFMPEG_AUTOCONF := --prefix=/usr
FFMPEG_AUTOCONF += --cross-prefix=$(COMPILER_PREFIX)
#FFMPEG_AUTOCONF += --cc=$(CROSS_CC)
#FFMPEG_AUTOCONF += --make=$(MAKE)
#FFMPEG_AUTOCONF += --source-path=$(FFMPEG_DIR)
#FFMPEG_AUTOCONF += --build-suffix=SUFFIX
FFMPEG_AUTOCONF += --extra-cflags="$(CROSS_CPPFLAGS) $(CROSS_CFLAGS) -L$(SYSROOT)/usr/lib"
FFMPEG_AUTOCONF += --extra-ldflags="$(CROSS_LDFLAGS) -L$(SYSROOT)/usr/lib"
FFMPEG_AUTOCONF += --extra-libs="$(CROSS_LIBS) -lm"
#FFMPEG_AUTOCONF += --enable-mingw32
#FFMPEG_AUTOCONF += --enable-mingwce
#FFMPEG_AUTOCONF += --enable-sunmlib
#FFMPEG_AUTOCONF += --disable-audio-beos

FFMPEG_AUTOCONF += --target-os=linux

ifdef PTXCONF_ARCH_X86
 FFMPEG_AUTOCONF += --disable-altivec
 FFMPEG_AUTOCONF += --disable-iwmmxt
 ifdef PTXCONF_ARCH_X86_I386
  FFMPEG_AUTOCONF += \
	--arch=x86_32 \
	--cpu=i386 \
	--tune=i386 \
	--disable-mmx
 endif
 ifdef PTXCONF_ARCH_X86_I486
  FFMPEG_AUTOCONF += \
	--arch=x86_32 \
	--cpu=i486 \
	--tune=i486 \
	--disable-mmx
 endif
 ifdef PTXCONF_ARCH_X86_I586
  FFMPEG_AUTOCONF += \
	--arch=x86_32 \
	--cpu=i386 \
	--cpu=i586 \
	--tune=i586
 endif
 ifdef PTXCONF_ARCH_X86_I686
  FFMPEG_AUTOCONF += \
	--arch=x86_32 \
	--cpu=i386 \
	--cpu=i686 \
	--tune=i686
 endif
 ifdef PTXCONF_ARCH_X86_P2
  FFMPEG_AUTOCONF += \
	--arch=x86_32 \
	--cpu=i386 \
	--cpu=i686 \
	--tune=pentium2
 endif
 ifdef PTXCONF_ARCH_X86_P3M
  FFMPEG_AUTOCONF += \
	--arch=x86_32 \
	--cpu=i386 \
	--cpu=i686 \
	--tune=pentium3
 endif
endif

ifdef PTXCONF_ARCH_ALPHA
FFMPEG_AUTOCONF += \
	--arch=alpha \
        --cpu=alpha \
        --disable-altivec \
        --disable-mmx \
        --disable-iwmmxt
endif

ifdef PTXCONF_ARCH_ARM
 ifdef PTXCONF_ARCH_ARM_IWMMXT
   FFMPEG_AUTOCONF += \
	--arch=arm \
	--cpu=iwmmxt \
	--disable-altivec \
	--disable-mmx
 else
# v5 fallback. Will not run on v4.
   FFMPEG_AUTOCONF += \
	--arch=arm \
	--cpu=arm926ej-s \
	--disable-altivec \
	--disable-mmx
 endif
endif

ifdef PTXCONF_ARCH_PPC
FFMPEG_AUTOCONF += \
	--cpu=powerpc \
	--disable-altivec \
	--disable-mmx \
	--disable-iwmmxt
# FFMPEG_AUTOCONF += --powerpc-perf-enable
endif

ifdef PTXCONF_ARCH_M68K
FFMPEG_AUTOCONF += \
	--cpu=m68k \
	--disable-altivec \
	--disable-mmx \
	--disable-iwmmxt
endif

ifdef PTXCONF_ARCH_SPARC
FFMPEG_AUTOCONF += \
	--cpu=sparc \
	--disable-altivec \
	--disable-mmx \
	--disable-iwmmxt
endif

ifdef PTXCONF_ARCH_MIPS
FFMPEG_AUTOCONF += \
	--disable-altivec \
	--disable-mmx \
	--disable-iwmmxt
endif

ifdef PTXCONF_ARCH_CRIS
FFMPEG_AUTOCONF += \
	--cpu=cris \
	--disable-altivec \
	--disable-mmx \
	--disable-iwmmxt
endif

ifdef PTXCONF_ARCH_PARISC
FFMPEG_AUTOCONF += \
	--cpu=parisc \
	--disable-altivec \
	--disable-mmx \
	--disable-iwmmxt
endif

ifdef PTXCONF_ARCH_SH
FFMPEG_AUTOCONF += \
	--cpu=sh4 \
	--disable-altivec \
	--disable-mmx \
	--disable-iwmmxt
endif

ifdef PTXCONF_FFMPEG_SHARED
FFMPEG_AUTOCONF += --enable-shared
else
FFMPEG_AUTOCONF += --disable-shared
endif

ifdef PTXCONF_FFMPEG_STATIC
FFMPEG_AUTOCONF += --enable-static
else
FFMPEG_AUTOCONF += --disable-static
endif

ifdef PTXCONF_FFMPEG_PTHREADS
FFMPEG_AUTOCONF += --enable-pthreads
endif

ifndef PTXCONF_FFMPEG_FFSERVER
FFMPEG_AUTOCONF += --disable-ffserver
endif

ifndef PTXCONF_FFMPEG_FFPLAY
FFMPEG_AUTOCONF += --disable-ffplay
endif

ifdef PTXCONF_FFMPEG_SMALL
FFMPEG_AUTOCONF += --enable-small
endif

ifdef PTXCONF_FFMPEG_MEMALIGN_HACK
FFMPEG_AUTOCONF += --enable-memalign-hack
endif

#ifndef PTXCONF_FFMPEG_STRIP
#FFMPEG_AUTOCONF += --disable-strip
#endif

ifdef PTXCONF_FFMPEG_GPROF
FFMPEG_AUTOCONF += --enable-gprof
endif

ifndef PTXCONF_FFMPEG_DEBUG
FFMPEG_AUTOCONF += --disable-debug
endif

ifdef PTXCONF_FFMPEG_GPL
FFMPEG_AUTOCONF += --enable-gpl
endif

ifdef PTXCONF_FFMPEG_MP3LAME
FFMPEG_AUTOCONF += --enable-mp3lame
endif

ifdef PTXCONF_FFMPEG_LIBOGG
FFMPEG_AUTOCONF += --enable-libogg
endif

ifdef PTXCONF_FFMPEG_VORBIS
FFMPEG_AUTOCONF += --enable-vorbis
endif

ifdef PTXCONF_FFMPEG_THEORA
FFMPEG_AUTOCONF += --enable-theora
endif

ifdef PTXCONF_FFMPEG_FAAD
FFMPEG_AUTOCONF += --enable-faad
endif

ifdef PTXCONF_FFMPEG_FAADBIN
FFMPEG_AUTOCONF += --enable-faadbin
endif

ifdef PTXCONF_FFMPEG_FAAC
FFMPEG_AUTOCONF += --enable-faac
endif

ifdef PTXCONF_FFMPEG_LIBGSM
FFMPEG_AUTOCONF += --enable-libgsm
endif

ifdef PTXCONF_FFMPEG_XVID
FFMPEG_AUTOCONF += --enable-xvid
endif

ifdef PTXCONF_FFMPEG_X264
FFMPEG_AUTOCONF += --enable-x264
endif

ifdef PTXCONF_FFMPEG_A52
FFMPEG_AUTOCONF += --enable-a52
endif

ifdef PTXCONF_FFMPEG_A52BIN
FFMPEG_AUTOCONF += --enable-a52bin
endif

ifdef PTXCONF_FFMPEG_DTS
FFMPEG_AUTOCONF += --enable-dts
endif

ifdef PTXCONF_FFMPEG_PP
FFMPEG_AUTOCONF += --enable-postproc
endif

ifdef PTXCONF_FFMPEG_AMR_NB
FFMPEG_AUTOCONF += --enable-amr_nb
endif

ifdef PTXCONF_FFMPEG_AMR_NB_FIXED
FFMPEG_AUTOCONF += --enable-amr_nb-fixed
endif

ifdef PTXCONF_FFMPEG_AMR_WB
FFMPEG_AUTOCONF += --enable-amr_wb
endif

ifdef PTXCONF_FFMPEG_AMR_IF2
FFMPEG_AUTOCONF += --enable-amr_if2
endif

ifdef PTXCONF_FFMPEG_DC1394
FFMPEG_AUTOCONF += --enable-dc1394
endif

ifndef PTXCONF_FFMPEG_NETWORK
FFMPEG_AUTOCONF += --disable-network
endif

ifndef PTXCONF_FFMPEG_ZLIB
FFMPEG_AUTOCONF += --disable-zlib
endif

#ifndef PTXCONF_FFMPEG_VHOOK
#FFMPEG_AUTOCONF += --disable-vhook
#endif

#ifndef PTXCONF_FFMPEG_MPEGAUDIO_HP
#FFMPEG_AUTOCONF += --disable-mpegaudio-hp
#endif

ifndef PTXCONF_FFMPEG_PROTOCOL
FFMPEG_AUTOCONF += --disable-protocols
endif

# FIXME selectivly enable/disable decoders to reduce library size

#--disable-encoder=NAME   disables encoder NAME
#--enable-encoder=NAME    enables encoder NAME
#--disable-decoder=NAME   disables decoder NAME
#--enable-decoder=NAME    enables decoder NAME
#--disable-encoders       disables all encoders
#--disable-decoders       disables all decoders
#--disable-muxers         disables all muxers
#--disable-demuxers       disables all demuxers

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/ffmpeg.targetinstall:
	@$(call targetinfo)

	@$(call install_init, ffmpeg)
	@$(call install_fixup, ffmpeg,PRIORITY,optional)
	@$(call install_fixup, ffmpeg,SECTION,base)
	@$(call install_fixup, ffmpeg,AUTHOR,"Erwin Rol <ero@pengutronix.de>")
	@$(call install_fixup, ffmpeg,DESCRIPTION,missing)

	@$(call install_copy, ffmpeg, 0, 0, 0644, -, \
		/usr/lib/libavcodec.so, n)
	@$(call install_link, ffmpeg, \
		libavcodec.so, \
		/usr/lib/libavcodec.so.53)
	@$(call install_link, ffmpeg, \
		libavcodec.so, \
		/usr/lib/libavcodec.so.53.61.100)

	@$(call install_copy, ffmpeg, 0, 0, 0644, -, \
		/usr/lib/libavfilter.so, n)
	@$(call install_link, ffmpeg, \
		libavfilter.so, \
		/usr/lib/libavfilter.so.2)
	@$(call install_link, ffmpeg, \
		libavfilter.so, \
		/usr/lib/libavfilter.so.2.61.100)

	@$(call install_copy, ffmpeg, 0, 0, 0644, -, \
		/usr/lib/libavformat.so, n)
	@$(call install_link, ffmpeg, \
		libavformat.so, \
		/usr/lib/libavformat.so.53)
	@$(call install_link, ffmpeg, \
		libavformat.so, \
		/usr/lib/libavformat.so.53.32.100)

	@$(call install_copy, ffmpeg, 0, 0, 0644, -, \
		/usr/lib/libavutil.so, n)
	@$(call install_link, ffmpeg, \
		libavutil.so, \
		/usr/lib/libavutil.so.51)
	@$(call install_link, ffmpeg, \
		libavutil.so, \
		/usr/lib/libavutil.so.51.35.100)

	@$(call install_copy, ffmpeg, 0, 0, 0644, -, \
		/usr/lib/libswresample.so, n)
	@$(call install_link, ffmpeg, \
		libswresample.so, \
		/usr/lib/libswresample.so.0)
	@$(call install_link, ffmpeg, \
		libswresample.so, \
		/usr/lib/libswresample.so.0.6.100)

	@$(call install_copy, ffmpeg, 0, 0, 0644, -, \
		/usr/lib/libswscale.so, n)
	@$(call install_link, ffmpeg, \
		libswscale.so, \
		/usr/lib/libswscale.so.2)
	@$(call install_link, ffmpeg, \
		libswscale.so, \
		/usr/lib/libswscale.so.2.1.100)

ifdef PTXCONF_FFMPEG_PP
	@$(call install_copy, ffmpeg, 0, 0, 0644, -, \
		/usr/lib/libpostproc.so, n)
	@$(call install_link, ffmpeg, \
		libpostproc.so, \
		/usr/lib/libpostproc.so.52)
	@$(call install_link, ffmpeg, \
		libpostproc.so, \
		/usr/lib/libpostproc.so.52.0.100)
endif

	@$(call install_finish, ffmpeg)

	@$(call touch)

# vim: syntax=make
