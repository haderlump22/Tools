#!/bin/bash

if [ $# != 2 ]
then
        echo "Verzeichnisname und Quellservername muessen angegeben werden"
        echo "$0 <DirectoryName> <Quellservername>"
        exit 0
else
        DirectoryName=$1
        SourceServer=$2
	PFAD=`dirname $(readlink -f ${0})`
fi

#copy DirectoryName
rsync -v -AXa --rsync-path='sudo /usr/bin/rsync' --exclude-from=$PFAD/rsync-exclude --stats -h username@$SourceServer:/<directory>/daten/$DirectoryName/ /<directory>/daten/$DirectoryName

echo "Nicht vergessen die Quelle zu löschen!!!"
