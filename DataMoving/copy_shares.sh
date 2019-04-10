#!/bin/bash

if [ $# != 2 ]
then
        echo "Verzeichnisname unterhalb von Userdaten und Quellservername muessen angegeben werden"
        echo "$0 <DirectoryName> <Quellservername>"
        exit 0
else
        DirectoryName=$1
        SourceServer=$2
fi

rsync -v -AXa --rsync-path='sudo /usr/bin/rsync' --stats -h username@$SourceServer:/userdaten/${DirectoryName}_bak/ /<directory>/daten/$DirectoryName

chgrp -R "domain users" /<directory>/daten/$DirectoryName
