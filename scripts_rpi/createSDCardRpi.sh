#!/bin/bash
#
# createSDCardRpi.sh
# 
# Copyright (c) 2012 - fga
#
# Based on instructions found here:
# - http://elinux.org/RPi_Advanced_Setup
# - http://www.omappedia.org/wiki/SD_Configuration
# - http://code.google.com/p/beagleboard/wiki/LinuxBootDiskFormat
#

# command line arguments
PARAMETERS=$@

# Declare usage display
usage="
$0:	\n
	\n
Usage: createSDCardRpi.sh /dev/sdx	[ -h ] \n	\n

	/dev/sdX				\t\t\t\t: SD card device (shouls be: sda, sdb, sdc...)	\n
	[ -h | --help | -u | --usage ]		\t: This help \n \n

	CAUTION: Take care not to use the device corresponding to you hard drive !\n
"

# Global variables
. config.ini
CMDLINE="dwc_otg.lpm_enable=0 console=ttyAMA0,115200 kgdboc=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 rootwait"

PTX_BSP=~/workspace/OSELAS.BSP-FG-Raspberry-2011.11.0
FIRMWARE_LOC=$PTX_BSP/platform-RaspberryPi/build-target/firmware-fc0232ac463f0618914bab9314e8e2ae27466d8c
FIRMWARE_BOOT=$FIRMWARE_LOC/boot
#images loc: Image, rootfs
IMAGES_SRC=$PTX_BSP/platform-RaspberryPi/images

# Mount point
SD_MNT_PT=/mnt/mmc
LOOP_MNT_PT=/mnt/loop

# Check Parameters
get_param()
{
	if [ -z "$PARAMETERS" ] ; then
		PARAMETERS="--usage"
	fi

	for PARAM in $PARAMETERS ; do
		case $PARAM in
		-h | --help | -u | --usage )
			echo -e $usage
			exit 1
			;;
		sd* ) 
			DEV_SDx_SDCARD=/dev/$PARAM
			# partition preffix: make sdc partion 1 to be "sdc1"
			part=
			;;
		/dev/sd* )
			DEV_SDx_SDCARD=$PARAM
			part=
			;;
		mmcblk* )
			DEV_SDx_SDCARD=/dev/$PARAM
			# partition preffix: make mmcblk0 partion 1 to be "mmcblk0p1"
			part=p
			;;
		/dev/mmcblk* )
			DEV_SDx_SDCARD=$PARAM
			part=p
			;;

		* )
			echo "Unknown option $PARAM !!!"
			exit
			;;
		esac
	done

	# Check parameters
	if [ -z "$DEV_SDx_SDCARD" ]; then
		echo -e $usage
		exit
	fi
}

# Declare check permission routine
check_permission () {
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
	echo "Only root can run this script (usage: sudo "$0")"
	exit
fi
}


# Declare exit routine
exit_failed()
{
	echo ""
	echo ""
	echo "*********************"
	echo "Failed: exiting."
	echo "*********************"
	exit 1
}


# Declare check SD device routine
check_SD_device()
{

	if [ -e $DEV_SDx_SDCARD ]; then
		echo $DEV_SDx_SDCARD has been found
		return 0
	else
		echo $DEV_SDx_SDCARD not found
		return 1
	fi
}


# Declare check_umount_all routine: unmount all mounted partition for a device
check_umount_all()
{
	dev=$1
	MNT=`mount | grep $dev | awk '{print $3}'`
	if [ -n "$MNT" ];then
		for mnt in $MNT; do
			echo -n "Unmounting $mnt ..."
			if sudo umount $mnt; then
				echo -e "\tDone."
			else
				echo "Failed."
				exit_failed
			fi
		done
	fi
}


# Declare Format SD device routine
formatSD () {
dev=$1
echo -n "formating : fdisk" $dev "... "

# retrieve disk size
disk_size=`sudo fdisk $DEV_SDx_SDCARD -su`
# We have to change geometry of the disk:
# - 255 heads
# - 63 sectors
# - XXX: cylinders number as follows:
# if we have 512 bytes per sector, 1 cylinder is 255 * 63 * 512 = 8225280 bytes
# new_cylinders = Size / 8225280
cylinders=$(( ($disk_size * 1024) / 8225280))
echo "cylinders $cylinders"

# erase first few bytes of the first sector, in case fdisk doesn't do it
sudo dd if=/dev/zero of=$dev bs=512 count=1 >/dev/null 2>&1


# p		: display partitions
# d1, d2, d3, d4: delete existing partition
# x		: expert mode
# h/255		: Set number of heads to 255
# s/63		: Set number of sectors to 63
# c/XXX		: Set number of cylinders to XXX
# r		: non-expert mode
# n/p/1/ /+64M	: create a new primary partition (nb 1) with 64Mb
# n/p/2/ / 	: create a new primary partition (nb 2) with remaining disk space
# t/1/c		: Change 1st partition 1 to c (W95 FAT32)
# a/1		: 1st partition bootable (amorce)
# p 		: display paritions
# w 		: write to SDcard
if sudo fdisk $dev >/dev/null 2>&1 <<EOF
p
d
1
d
2
d
3
d
4
x
h
255
s
63
c
$cylinders
r
n
p
1

+64M
n
p
2


t
1
c
a
1
p
w
EOF

then
	echo -e "\tDone."
	
	# display partitions
	sudo fdisk -ls $dev

	sleep 2

	check_umount_all $dev

	echo -n "Creating FAT32 file system on "$dev$part"1 ... "
	if sudo mkfs.vfat -F32 -n boot "$dev""$part"1  >/dev/null 2>&1; then
		echo -e "\tDone."
	else
		echo "Failed."
		exit_failed
	fi

# TODO (remove return) and continue with 2nd partition
#	return 0

	echo -n "Creating ext4 file system on "$dev$part"2 ... "
	# Create ext4 file system
	if sudo mkfs.ext4 -L rootfs "$dev""$part"2  >/dev/null 2>&1; then
		echo -e "\tDone."
	else
		echo "Failed."
		exit_failed		
	fi
else
	exit_failed
	return 1
fi
return 0
}


copy_bootloader()
{
	dev=$1
	if [ ! -e $SD_MNT_PT ]; then
		echo -n "Creating SD card mountpoint ... "
		# Create mounting point
		if sudo mkdir $SD_MNT_PT; then
			echo -e "\tDone."
		else
			echo -e "\tFailed."
			echo "Cannot Create mounting point : $SD_MNT_PT"
			exit_failed
		fi
	fi


	if [ -d $FIRMWARE_BOOT ]; then
		echo -n "Mounting SD card boot partition "$dev$part"1 ... "
		# Mount SD card boot partition
		if sudo mount -t vfat $dev$part"1" $SD_MNT_PT; then
			echo -e "\tDone."
		else
			echo -e "\tFailed."
			exit_failed
		fi
	else
			echo -e "\tFailed."
			echo "Cannot find firmware boot: $FIRMWARE"
			exit_failed		
	fi

	# Change dir to mounted SD Card Partition
	pushd $SD_MNT_PT

	# Copy MLO, barebox
	echo -n "Copying boot firmware to SD card ..."
	if sudo cp $FIRMWARE_BOOT/* $SD_MNT_PT; then
		echo -e "\tDone."
	else
		echo -e "\tFailed."
		popd
		exit_failed
	fi

	echo -n "Creating cmdline.txt ..."
	if sudo sh -c "echo $CMDLINE > $SD_MNT_PT/cmdline.txt"; then
		echo -e "\tDone."
	else
		echo -e "\tFailed."
		popd
		exit_failed
	fi

	echo -n "Copying linuximage ..."
	if sudo cp $IMAGES_SRC/linuximage $SD_MNT_PT/kernel.img; then
		echo -e "\tDone."
	else
		echo -e "\tFailed."
		popd
		exit_failed
	fi

	popd
	echo -n "Uounting SD card boot partition "$dev$part"1 ... "
	if sudo umount $SD_MNT_PT >/dev/null 2>&1; then
		echo -e "\tDone."
	else
		echo -e "\tFailed."
		popd
		exit_failed
	fi
}

copy_rootfs()
{
	dev=$1
	if [ ! -e $SD_MNT_PT ]; then
		echo -n "Creating SD card mountpoint ... "
		# Create mounting point
		if sudo mkdir $SD_MNT_PT; then
			echo -e "\tDone."
		else
			echo -e "\tFailed."
			echo "Cannot Create mounting point : $SD_MNT_PT"
			exit_failed
		fi
	fi

	if [ ! -e $LOOP_MNT_PT ]; then
		echo -n "Creating rootfs image mountpoint ... "
		# Create mounting point
		if sudo mkdir $LOOP_MNT_PT; then
			echo -e "\tDone."
		else
			echo -e "\tFailed."
			echo "Cannot Create mounting point : $LOOP_MNT_PT"
			exit_failed
		fi
	fi


	if [ -f $IMAGES_SRC/root.ext2 ]; then
		echo -n "Mounting SD card boot partition "$dev$part"2 ... "
		# Mount SD card boot partition
		if sudo mount $dev$part"2" $SD_MNT_PT; then
			echo -e "\tDone."
			echo -n "Mounting loopback $IMAGES_SRC/root.ext2 ... "
			if sudo mount -o loop $IMAGES_SRC/root.ext2 $LOOP_MNT_PT; then
				echo -e "\tDone."
			else
				echo -e "\tFailed."
				exit_failed
			fi
		else
			echo -e "\tFailed."
			exit_failed
		fi
	else
			echo -e "\tFailed."
			echo "Cannot find : $IMAGES_SRC/root.ext2"
			exit_failed		
	fi

	# Copy rootfs to SD card
	echo -n "Copying rootfs to SD card ..."
	if sudo sh -c "(cd $LOOP_MNT_PT; tar cf - .) | (cd $SD_MNT_PT; tar xpf -)"; then
		echo -e "\tDone."
	else
		echo -e "\tFailed."
		popd
		exit_failed
	fi

	echo -n "Uounting SD card boot partition "$dev$part"2 ... "
	if sudo umount $SD_MNT_PT >/dev/null 2>&1; then
		echo -e "\tDone."
	else
		echo -e "\tFailed."
		popd
		exit_failed
	fi

	sudo umount $LOOP_MNT_PT >/dev/null 2>&1
}

# Read command line args
get_param


# Check device exists
if check_SD_device $DEV_SDx_SDCARD; then

	# Check for mounted partitions, unmount when necessary
	check_umount_all $DEV_SDx_SDCARD

	# Format device
	formatSD $DEV_SDx_SDCARD

	# Check for mounted partitions, unmount when necessary
	check_umount_all $DEV_SDx_SDCARD
	
	# Copy firmware, kernel image
	copy_bootloader $DEV_SDx_SDCARD

	sleep 2

	# Check for mounted partitions, unmount when necessary
	check_umount_all $DEV_SDx_SDCARD

	copy_rootfs $DEV_SDx_SDCARD

	# Check for mounted partitions, unmount when necessary
	check_umount_all $DEV_SDx_SDCARD

fi

