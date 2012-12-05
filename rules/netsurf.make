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
PACKAGES-$(PTXCONF_NETSURF) += netsurf

#
# Paths and names
#
NETSURF_VERSION	:= 2.9
NETSURF_MD5	:= cfc2789997b356f2ea9d9f7694c4c909
NETSURF		:= netsurf-$(NETSURF_VERSION)
NETSURF_SUFFIX	:= -full-src.tar.gz
NETSURF_URL	:= http://download.netsurf-browser.org/netsurf/releases/source-full//$(NETSURF)$(NETSURF_SUFFIX)
NETSURF_SOURCE	:= $(SRCDIR)/$(NETSURF).$(NETSURF_SUFFIX)
NETSURF_DIR	:= $(BUILDDIR)/$(NETSURF)
NETSURF_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

NETSURF_PATH    	:= PATH=$(CROSS_PATH)
NETSURF_CFLAGS		:= $(CROSS_CPPFLAGS) -Wno-error=enum-compare

NETSURF_LDFLAGS		:= -lcurl
NETSURF_LDFLAGS		+= -ljpeg
NETSURF_LDFLAGS		+= -lpng
NETSURF_LDFLAGS		+= -lcrypto
NETSURF_LDFLAGS		+= -lssl
NETSURF_LDFLAGS		+= -lSDL
NETSURF_LDFLAGS		+= -lxml2
NETSURF_LDFLAGS		+= -lz
NETSURF_LDFLAGS		+= -lm
NETSURF_LDFLAGS		+= -lcss
NETSURF_LDFLAGS		+= -lparserutils
NETSURF_LDFLAGS		+= -lhubbub
NETSURF_LDFLAGS		+= -lwapcaplet
NETSURF_LDFLAGS		+= -lnsfb
NETSURF_LDFLAGS		+= -lnsgif
NETSURF_LDFLAGS		+= -lsvgtiny
NETSURF_LDFLAGS		+= -lnsbmp
NETSURF_LDFLAGS		+= -lhubbub
NETSURF_LDFLAGS		+= -lrosprite

ifdef PTXCONF_NETSURF_TARGET_FRAMEBUFFER
NETSURF_TARGETOPT	:= TARGET=framebuffer
endif

ifdef PTXCONF_NETSURF_TARGET_GTKDFB
NETSURF_TARGETOPT	:= TARGET=gtk
NETSURF_CFLAGS		+= -I$(SYSROOT)/usr/include/gtk-2.0
NETSURF_CFLAGS		+= -I$(SYSROOT)/usr/lib/gtk-2.0/include
NETSURF_CFLAGS		+= -I$(SYSROOT)/usr/include/cairo
NETSURF_CFLAGS		+= -I$(SYSROOT)/usr/include/glib-2.0
NETSURF_CFLAGS		+= -I$(SYSROOT)/usr/lib/glib-2.0/include
NETSURF_CFLAGS		+= -I$(SYSROOT)/usr/include/pango-1.0
NETSURF_CFLAGS		+= -I$(SYSROOT)/usr/include/atk-1.0/

NETSURF_LDFLAGS		+= -lgtk-directfb-2.0
NETSURF_LDFLAGS		+= -lgdk_pixbuf-2.0
NETSURF_LDFLAGS		+= -lgdk-directfb-2.0
NETSURF_LDFLAGS		+= -lpangocairo-1.0
NETSURF_LDFLAGS		+= -lpango-1.0 -lm
NETSURF_LDFLAGS		+= -lcairo
NETSURF_LDFLAGS		+= -lgobject-2.0
NETSURF_LDFLAGS		+= -latk-1.0
NETSURF_LDFLAGS		+= -lglib-2.0
NETSURF_LDFLAGS		+= -lglade-2.0
endif

NETSURF_TARGETOPT	+= NETSURF_USE_WEBP=NO
NETSURF_TARGETOPT	+= NETSURF_USE_VIDEO=NO
NETSURF_TARGETOPT	+= NETSURF_USE_RSVG=NO
NETSURF_TARGETOPT	+= NETSURF_USE_NSSVG=YES
NETSURF_TARGETOPT	+= NETSURF_USE_MNG=NO

ifdef PTXCONF_NETSURF_FREETYPE
NETSURF_TARGETOPT	+= NETSURF_FB_FONTLIB=freetype
NETSURF_LDFLAGS		+= -lfreetype
endif


NETSURF_MAKE_OPT	:= $(CROSS_ENV) PREFIX=/usr Q= $(NETSURF_TARGETOPT)  OPTCFLAGS="$(NETSURF_CFLAGS)" LDFLAGS="$(CROSS_LDFLAGS) $(NETSURF_LDFLAGS)"
NETSURF_INSTALL_OPT	:= $(NETSURF_MAKE_OPT) install

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/netsurf.targetinstall:
	@$(call targetinfo)

	@$(call install_init, netsurf)
	@$(call install_fixup, netsurf,PRIORITY,optional)
	@$(call install_fixup, netsurf,SECTION,base)
	@$(call install_fixup, netsurf,AUTHOR,"fabricega")
	@$(call install_fixup, netsurf,DESCRIPTION,missing)

	@$(call install_copy, netsurf, 0, 0, 0755, $(NETSURF_PKGDIR)/usr/bin/netsurf, /usr/bin/netsurf.bin)
	@$(call install_alternative, netsurf, 0, 0, 0755, /usr/bin/netsurf)

	@cd $(NETSURF_PKGDIR)/usr/share/netsurf && \
		find . -type f | while read file; do \
		$(call install_copy, netsurf, 0, 0, 644, \
		$(NETSURF_PKGDIR)/usr/share/netsurf/$$file, \
		/usr/share/netsurf/$$file); \
	done

	@$(call install_finish, netsurf)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#ifdef PTXCONF_NETSURF
#$(STATEDIR)/netsurf.clean: $(STATEDIR)/hubbub.clean $(STATEDIR)/libcss.clean $(STATEDIR)/libnsfb.clean $(STATEDIR)/libnsbmp.clean $(STATEDIR)/libparserutils.clean  $(STATEDIR)/libwapcaplet.clean  $(STATEDIR)/libsvgtiny.clean
#endif
#	@$(call targetinfo)
#	@$(call clean_pkg, NETSURF)

# vim: syntax=make
