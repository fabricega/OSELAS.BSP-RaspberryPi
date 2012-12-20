#!/bin/bash

package_name=$1
package_dir=`find $PTX_BSP/platform-$PLATFORM/packages/ -type d -name "$package_name*" | grep -v ".tmp" | grep -v "linux-*" | sed ':a;N;$!ba;s/\n/%/g' | cut -d '%' -f1`

to_lowercase() {
	echo "${1,,}"
}

to_uppercase() {
	echo "${1^^}"
}

check_busybox_dep() {
	cmd_name=$1
	CMD_NAME=`to_uppercase $cmd_name`
	busybox_cmd=`grep -rn BUSYBOX_"$CMD_NAME" $PTXLIB/config/busybox | grep BUSYBOX_"$CMD_NAME" | cut -d ' ' -f2`

	if [ -n "$busybox_cmd" ]; then
		echo BUSYBOX_"$CMD_NAME"
	fi
}

print_config() {
	cmd_name=$1
	CMD_NAME=`to_uppercase $cmd_name`
	PACKAGE_NAME=`to_uppercase $package_name | sed s/-/_/g`
	BUSYBOX_DEP=$(check_busybox_dep $cmd_name)

	echo -e "config "$PACKAGE_NAME"_"$CMD_NAME
	echo -e "\tbool"
	echo -e "\tprompt "\"$cmd_name\"
	echo -e "\tdefault n "

	if [ -n "$BUSYBOX_DEP" ]; then
	echo -e "\tdepends on !$BUSYBOX_DEP"
	fi

	echo -e "\thelp"
	echo -e "\t  FIXME"
	echo ""

	if [ -n "$BUSYBOX_DEP" ]; then
	echo -e "comment \"BusyBox' $cmd_name is selected!\""
	echo -e "\tdepends on $BUSYBOX_DEP"
	echo ""
	fi
}

print_make() {
	cmd_name=$2
	cmd=$1
	CMD_NAME=`to_uppercase $cmd_name`
	PACKAGE_NAME=`to_uppercase $package_name | sed s/-/_/g`
	echo "ifdef PTXCONF_"$PACKAGE_NAME"_"$CMD_NAME
	echo -e '\t@$(call install_copy, '$package_name", 0, 0, 0755, -, $cmd)"
	echo "endif"
	echo ""
}

pushd "$package_dir"
if [ -d "$package_dir/bin" ]; then
	cmd_list="$cmd_list "`find ./bin -type f | sed "s#\./#/#g"`
fi
if [ -d "$package_dir/sbin" ]; then
	cmd_list="$cmd_list "`find ./sbin -type f | sed "s#\./#/#g"`
fi
if [ -d "$package_dir/usr/bin" ]; then
	cmd_list="$cmd_list "`find ./usr/bin -type f | sed "s#\./#/#g"`
fi
if [ -d "$package_dir/usr/sbin" ]; then
	cmd_list="$cmd_list "`find ./usr/sbin -type f | sed "s#\./#/#g"`
fi
popd

echo "Commands found : "
cmd_list=`echo $cmd_list | sed 's# #\n#g' | sort`
echo $cmd_list 

# print Kconfig
for cmd in $cmd_list ; do
	cmd_name=`echo $cmd | sed 's#/usr##g' | sed 's#/bin##g' | sed 's#/sbin##g' | sed 's#/##g'`
	print_config $cmd_name
done

# print ptxdist targetinstall (make) rules
for cmd in $cmd_list ; do
	cmd_name=`echo $cmd | sed 's#/usr##g' | sed 's#/bin##g' | sed 's#/sbin##g' | sed 's#/##g'`
	print_make $cmd $cmd_name
done

