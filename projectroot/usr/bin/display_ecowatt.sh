#!/bin/bash
ARG=$1
LOG_PATH=/var/www/GnOmeDataCenter/log
LOG_OUT=/var/www/GnOmeDataCenter/out
DATE=`date "+%s"`
#DATE_DEBUT=`date "+%Y-%m-%d" -d "$NB_DAY days ago"`

export GDFONTPATH=/usr/share/font/

if [ "$ARG" = "MOIS" ]
then
	FORMAT_X="%m/%y"
	FILEOUT="ecowatt_m.png"
else
	FORMAT_X="%d/%m/%y"
	FILEOUT="ecowatt_j.png"
fi


function genere_ecowatt_cmd()
{
cat <<EOF
set xlabel " consommation en KWatt"
set format x "$FORMAT_X"
set autoscale
set grid
set xdata time
set timefmt "$FORMAT_X"
set xtics rotate by -60
plot "ecowatt.dat$DATE"  using 1:2 with boxes  title 'ecowatt'
set term png
set output "$LOG_OUT/$FILEOUT"
replot
EOF
}



function split_file()
{
	if [ "$ARG" = "MOIS" ]
	then
		cat $LOG_PATH/120704_0817_data.csv | tail -13 | head -9 | awk -F";" '{print $1" "$3}' > ecowatt.dat$DATE
	else
		cat $LOG_PATH/120704_0817_data.csv | tail -272 | head -256 | awk -F";" '{print $1" "$3}' > ecowatt.dat$DATE
	fi

}

genere_ecowatt_cmd > ecowatt.cmd$DATE
split_file
gnuplot < ecowatt.cmd$DATE
rm ecowatt.cmd$DATE
rm ecowatt.dat$DATE




