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
PACKAGES-$(PTXCONF_LINUX_FUSION) += linux-fusion

#
# Paths and names
#
LINUX_FUSION_VERSION	:= 8.10.4
LINUX_FUSION_MD5	:= 0afcdfbd3aeaf61eef3100ffc4692417
LINUX_FUSION		:= linux-fusion-$(LINUX_FUSION_VERSION)
LINUX_FUSION_SUFFIX	:= tar.gz
LINUX_FUSION_URL	:= http://directfb.org/downloads/Core/linux-fusion//$(LINUX_FUSION).$(LINUX_FUSION_SUFFIX)
LINUX_FUSION_SOURCE	:= $(SRCDIR)/$(LINUX_FUSION).$(LINUX_FUSION_SUFFIX)
LINUX_FUSION_DIR	:= $(BUILDDIR)/$(LINUX_FUSION)
LINUX_FUSION_LICENSE	:= unknown

ifdef PTXCONF_LINUX_FUSION
$(STATEDIR)/kernel.targetinstall.post: $(STATEDIR)/linux-fusion.targetinstall
endif

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

LINUX_FUSION_ENV	:= \
	KERNELDIR=$(BUILDDIR)/linux-$(KERNEL_VERSION) \
	HOSTCC=$(HOSTCC) \
	ARCH=$(PTXCONF_KERNEL_ARCH_STRING) \
	CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) \
	INSTALL_MOD_PATH=$(PKGDIR)/linux-$(KERNEL_VERSION) \
	KERNEL_VERSION=$(KERNEL_VERSION)

LINUX_FUSION_MAKE_OPT		:= modules $(LINUX_FUSION_ENV)
LINUX_FUSION_INSTALL_OPT	:= modules_install $(LINUX_FUSION_ENV)

$(STATEDIR)/linux-fusion.prepare: $(STATEDIR)/kernel.install
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/linux-fusion.install:
	@$(call targetinfo)
	echo $(LINUX_FUSION_INSTALL_OPT)
	@$(call world/install, LINUX_FUSION)
	cd $(LINUX_FUSION_DIR) && \
		$(LINUX_FUSION_PATH) $(LINUX_FUSION_ENV) \
		$(MAKE) headers_install SYSROOT=$(SYSROOT)
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/linux-fusion.targetinstall:
	@$(call targetinfo)
	@$(call touch)


ifdef PTXCONF_LINUX_FUSION
$(STATEDIR)/kernel.clean: $(STATEDIR)/linux-fusion.clean
endif

# vim: syntax=make
