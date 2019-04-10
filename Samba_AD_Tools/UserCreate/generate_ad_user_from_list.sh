#!/bin/bash
function convert {
	echo $1 | sed -e 's/ä/ae/g;s/ü/ue/g;s/ö/oe/g;s/ß/ss/g'	
}
if [ $# != 1 ]
then
        echo "Datei mit der Userliste und der Name des Homeservers muss angegeben werden!"
        echo "$0 <listname>"
        exit 0
else
	array=$(cat $1)

	for item in $array; do

		USER=$(echo $item | cut -d\; -f1)
		GN=$(echo $item | cut -d\; -f2)
		SN=$(echo $item | cut -d\; -f3)
		PW=$(echo $item | cut -d\; -f4)
		SERVER=$(echo $item | cut -d\; -f5)
		#falls NULL als Server uebergeben wird soll kein UNC Pfad bei der anlage des Users mitgeteilt werden, dann ist der Inhalt
		#der Variable einfach leer
		if [ $SERVER == "NULL" ]
		then
			UNCPROFIL=""
			UNCUSER=""
		else
                        UNCPROFIL="--profile-path=\\\\$SERVER\\profile\\$USER"
                        UNCUSER="--home-drive=H: --home-directory=\\\\$SERVER\\users\\$USER"
                fi
                MAILADDRESS=$(convert $(echo $GN | tr [:upper:] [:lower:])'.'$(echo $SN | tr [:upper:] [:lower:])'@deutsche-rs.de')

                echo "lege $GN $SN mit dem login $USER und dem Homeserver $SERVER an. Mail ist $MAILADDRESS" 
                samba-tool user create $USER $PW --given-name=$GN --surname=$SN $UNCPROFIL $UNCUSER --mail-address=$MAILADDRESS
		samba-tool user setexpiry $USER --noexpiry
	done
fi
