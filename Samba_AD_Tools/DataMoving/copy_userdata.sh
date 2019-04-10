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

rsync -v -AXa --rsync-path='sudo /usr/bin/rsync' --exclude-from=$PFAD/rsync-exclude --stats -h username@$SourceServer:/userdaten/$Username/ /<directory>/UserHomes/$Username

#set ACLs
sed '1,$s/USERNAME/'"$Username"'/g' UH_facl.conf > facltemp
cd /<directory>/UserHomes
setfacl --restore=/home/<username>/MakeADmember/facltemp
cd /home/<username>/MakeADmember
rm facltemp

#set Userpermissions
chown -R $Username:"domain users" /<directory>/UserHomes/$Username/*
