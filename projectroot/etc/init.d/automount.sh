#!/bin/sh

PIDFILE=/var/run/automout.pid

do_mount ()
{
	dev=$1
	case $dev in
		
	sd[a-z][0-9]*)
		if [ -z "`cat /proc/mounts | grep $dev`" ]; then
			echo "mount $dev"
			udisks --mount /dev/$dev
		fi
	;;

	esac
}

do_unmount ()
{
	dev=$1
	case $dev in
		
	sd[a-z][0-9]*)
		if [ -n "`cat /proc/mounts | grep $dev`" ]; then
			echo "unmount $dev"
			udisks --unmount /dev/$dev
		fi
	;;

	esac
}

automount ()
{	
	# Copyright (C) 2009-2010 OpenELEC.tv
	drive_dump () {
		udisks --dump | tr -d ' ' | grep 'device-file:' | cut -d ':' -f2
	}

	show_info () {
		udisks --show-info $2 | grep "$1:" | tr -d ' ' | cut -d ":" -f2
	}

	for DEVICE in `drive_dump`; do
		REMOVABLE="`show_info "removable" $DEVICE`"
		MOUNTED="`show_info "is mounted" $DEVICE`"
		USAGE="`show_info "usage" $DEVICE`"

		if [ "$REMOVABLE" = "0" -a "$MOUNTED" = "0" -a "$USAGE" = "filesystem" ]; then
		echo "$DEVICE / $REMOVABLE / $MOUNTED / $USAGE"
		udisks --mount "$DEVICE" >/dev/null
		fi
	done
	# end of openelec

	udisks --monitor | while read ev; do
		dev=`echo $ev | sed 's/^.*devices\///g'`
		case "$ev" in
			added*)
				do_mount $dev
			;;
			removed:*)
				do_unmount $dev
				;;
	#		*)
	#			echo "unknow ev: $ev"
		esac
	done
}

case "$1" in
	start)
		echo 'Starting automount ...'
    		automount &
		PID=$!
		echo $PID > $PIDFILE
		;;
	stop)
		echo 'Stopping automount'
		if [ -e $PIDFILE ]; then
    			kill `cat $PIDFILE` > /dev/null 2>&1
			killall udisks
			rm $PIDFILE
		fi
		;;
	restart)
		$0 stop
		sleep 1
		$0 start
		;;
	*)
		echo "usage: $0 {start|stop|restart}"
esac


