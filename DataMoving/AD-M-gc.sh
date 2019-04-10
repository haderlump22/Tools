#!/bin/bash
#AD Member Garbage Collector
#raeumt UserHome und UserProfile von geloeschten Usern auf

if [ "$1" == "-x" ]; then
	if [ "$2" == "" ]; then
		echo "username muss angegeben werden"
		echo "nutze AD-M-gc.sh -x gefolgt vom username"
		exit 0
	else
		login="$2"
	fi
else
	echo "Bitte folgenden Syntax benutzen:"
	echo "AD-M-gc.sh -x gefolgt vom username"
	exit 0
fi


case $1 in

-x)
	#verzeichnisse des users archivieren
	tar -cvz --acls --xattrs -f /<directrory>/$login.tar.gz /<directrory>/UserHomes/$login /<directrory>/UserProfiles/$login.*
	rm -R /<directrory>/UserHomes/$login /<directrory>/UserProfiles/$login.*
esac
