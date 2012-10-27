# -*-makefile-*-
#
# Copyright (C) 2006 by Robert Schwebel
# Copyright (C) 2009 by Juergen Beisert <j.beisert@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_MYSQL) += mysql

#
# Paths and names
#
MYSQL_VERSION	:= 5.1.55
MYSQL_MD5	:= e07e79edad557874d0870c914c9c81e1
MYSQL		:= mysql-$(MYSQL_VERSION)
MYSQL_SUFFIX	:= tar.gz
MYSQL_URL	:= http://www.pengutronix.de/software/ptxdist/temporary-src/$(MYSQL).$(MYSQL_SUFFIX) \
		   http://downloads.mysql.com/archives/mysql-5.1/$(MYSQL).$(MYSQL_SUFFIX)
MYSQL_SOURCE	:= $(SRCDIR)/$(MYSQL).$(MYSQL_SUFFIX)
MYSQL_DIR	:= $(BUILDDIR)/$(MYSQL)
MYSQL_LICENSE	:= GPLv2

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(MYSQL_SOURCE):
	@$(call targetinfo)
	@$(call get, MYSQL)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

MYSQL_ENV := \
	$(CROSS_ENV) \
	ac_cv_path_COMP_ERR=$(PTXCONF_SYSROOT_HOST)/bin/comp_err \
	ac_cv_path_GEN_LEX_HASH=$(PTXCONF_SYSROOT_HOST)/bin/gen_lex_hash
#
# autoconf
#
MYSQL_AUTOCONF := \
	$(CROSS_AUTOCONF_USR) \
	--with-zlib-dir=$(SYSROOT)/usr \
	--without-debug \
 --enable-shared \
  --enable-thread-safe-client -with-extra-charsets=complex \
  --with-readline=/usr --without-readline \
  --without-server --without-docs --without-man \
  ac_cv_sys_restartable_syscalls=yes \
  ac_cv_path_PS=/bin/ps \
  ac_cv_FIND_PROC="/bin/ps p \$\$PID | grep -v grep | grep mysqld > /dev/null" \
  ac_cv_have_decl_HAVE_IB_ATOMIC_PTHREAD_T_GCC=yes \
  ac_cv_have_decl_HAVE_IB_ATOMIC_PTHREAD_T_SOLARIS=no \
  ac_cv_have_decl_HAVE_IB_GCC_ATOMIC_BUILTINS=yes


$(STATEDIR)/mysql.prepare:
	@$(call targetinfo)
	@$(call clean, $(MYSQL_DIR)/config.cache)
	cd $(MYSQL_DIR) && \
		$(MYSQL_PATH) $(MYSQL_ENV) \
		autoreconf -vif
	cd $(MYSQL_DIR) && \
		$(MYSQL_PATH) $(MYSQL_ENV) \
		./configure $(MYSQL_AUTOCONF)
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/mysql.targetinstall:
	@$(call targetinfo)

	@$(call install_init, mysql)
	@$(call install_fixup, mysql,PRIORITY,optional)
	@$(call install_fixup, mysql,SECTION,base)
	@$(call install_fixup, mysql,AUTHOR,"Robert Schwebel <r.schwebel\@pengutronix.de>")
	@$(call install_fixup, mysql,DESCRIPTION,missing)

#	# install server stuff
#	# --------------------
ifdef PTXCONF_MYSQL_SERVER
	@$(call install_copy, mysql, 0, 0, 0755, -, /usr/libexec/mysqld)
	@$(call install_copy, mysql, 0, 0, 0755, -, /usr/bin/mysqld_safe,n)

#	# FIXME: need more languages?
	@$(call install_copy, mysql, 0, 0, 0755, -, /usr/share/mysql/english/errmsg.sys,n)

#	# install management scripts
#	# --------------------------
#	# install_db:
	@$(call install_copy, mysql, 0, 0, 0755, -, /usr/bin/mysql_install_db,n)
	@$(call install_copy, mysql, 0, 0, 0755, -, /usr/bin/my_print_defaults)
	@$(call install_copy, mysql, 0, 0, 0755, -, /usr/share/mysql/fill_help_tables.sql,n)
	@$(call install_copy, mysql, 0, 0, 0755, -, /usr/share/mysql/mysql_fix_privilege_tables.sql,n)
	@$(call install_copy, mysql, 0, 0, 0755, -, /usr/bin/resolveip)
	@$(call install_copy, mysql, 0, 0, 0755, -, /usr/bin/mysql_create_system_tables)
endif

#	# install client stuff
#	# --------------------------
	@$(call install_copy, mysql, 0, 0, 0755, -, /usr/bin/mysql)
	@$(call install_copy, mysql, 0, 0, 0755, -, /usr/bin/mysqladmin)
	@$(call install_copy, mysql, 0, 0, 0755, -, /usr/bin/mysql_upgrade)
	@$(call install_copy, mysql, 0, 0, 0755, -, /usr/bin/mysqlcheck)
	@$(call install_copy, mysql, 0, 0, 0755, -, /usr/bin/mysqldump)

	@$(call install_lib, mysql, 0, 0, 0644, mysql/libmysqlclient)

#	# libmyodbc3_r-3.51.27.so uses this library:
	@$(call install_lib, mysql, 0, 0, 0644, mysql/libmysqlclient_r)

ifdef PTXCONF_INITMETHOD_BBINIT
ifdef PTXCONF_MYSQL_STARTSCRIPT
	@$(call install_alternative, mysql, 0, 0, 0755, /etc/init.d/mysql, n)

ifneq ($(call remove_quotes,$(PTXCONF_MYSQL_BBINIT_LINK)),)
	@$(call install_link, mysql, \
		../init.d/mysql, \
		/etc/rc.d/$(PTXCONF_MYSQL_BBINIT_LINK))
endif
endif
endif

	@$(call install_finish, mysql)

	@$(call touch)

# vim: syntax=make
