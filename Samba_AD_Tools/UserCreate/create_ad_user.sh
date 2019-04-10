#!/bin/bash
function convert {
	echo $1 | sed -e 's/ä/ae/g;s/ü/ue/g;s/ö/oe/g;s/ß/ss/g'	
}

if [ $# != 4 ]
then
        echo "login Vorname Nachname und Abteilungsserver müssen angegeben werden!"
        echo "$0 <login> <Vorname> <Nachname> <Abteilungsserver>"
        exit 0
else
	USER=$1
	GN=$2
	SN=$3
	SERVER=$4
	MAILADDRESS=$(convert $(echo $GN | tr [:upper:] [:lower:])'.'$(echo $SN | tr [:upper:] [:lower:])'@deutsche-rs.de')
fi

samba-tool user create $USER --given-name=$GN --surname=$SN --profile-path=\\\\${SERVER}\\profile\\$USER --home-drive=H: --home-directory=\\\\${SERVER}\\users\\$USER --mail-address=$MAILADDRESS
samba-tool user setexpiry $USER --noexpiry
