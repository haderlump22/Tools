#!/bin/bash
function convert {
	echo $1 | sed -e 's/ä/ae/g;s/ü/ue/g;s/ö/oe/g;s/ß/ss/g'	
}

if [ $# != 3 ]
then
        echo "login Vorname Nachname und Abteilungsserver müssen angegeben werden!"
        echo "$0 <login> <Vorname> <Nachname>"
        exit 0
else
	USER=$1
	GN=$2
	SN=$3
	MAILADDRESS=$(convert $(echo $GN | tr [:upper:] [:lower:])'.'$(echo $SN | tr [:upper:] [:lower:])'@deutsche-rs.de')
fi

samba-tool user create $USER --given-name=$GN --surname=$SN --mail-address=$MAILADDRESS
samba-tool user setexpiry $USER --noexpiry
