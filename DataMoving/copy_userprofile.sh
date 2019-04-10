#!/bin/bash

if [ $# != 2 ]
then
        echo "login und Quellservername muessen angegeben werden"
        echo "$0 <login> <Quellservername>"
        exit 0
else
        Username=$1
        SourceServer=$2
fi

rsync -v -AXa --rsync-path='sudo /usr/bin/rsync' --stats -h username@$SourceServer:/userdaten/ntprofile/profiles/${Username}.V2/ /<directory>/UserProfiles/${Username}.V2


#set ACLs
sed '1,$s/USERNAME/'"$Username"'/g' UP_facl.conf > facltemp
cd /<directory>/UserProfiles/
setfacl --restore=/home/<username>/MakeADmember/facltemp
cd /home/<username>/MakeADmember
#rm facltemp

#set Userpermissions
chown -R $Username:"domain users" /<directory>/UserProfiles/${Username}.V2/*
