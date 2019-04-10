#!/bin/bash

if [ $# != 2 ]
then
        echo "login und Quellservername muessen angegeben werden"
        echo "$0 <login> <Quellservername>"
        exit 0
else
        Username=$1
        SourceServer=$2
	PFAD=`dirname $(readlink -f ${0})`
fi

#copy Userdata
rsync -v -AXa --rsync-path='sudo /usr/bin/rsync' --exclude-from=$PFAD/rsync-exclude --stats -h username@$SourceServer:/<directory>/UserHomes/$Username/ /<directory>/UserHomes/$Username
#copy Profile
rsync -v -AXa --rsync-path='sudo /usr/bin/rsync' --stats -h username@$SourceServer:/<directory>/UserProfiles/${Username}* /<directory>/UserProfiles/
