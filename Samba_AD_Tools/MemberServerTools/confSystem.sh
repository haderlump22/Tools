#!/bin/bash

#install some Packages
apt-get update
apt-get install aptitude
aptitude install samba smbclient winbind heimdal-clients libnss-winbind libpam-winbind ntp exim4 mailx unattended-upgrades

#create /etc/krb5.conf
cat krb5.conf > /etc/krb5.conf
chmod 644 /etc/krb5.conf

#create /etc/samba/smb.conf
cat smb.conf > /etc/samba/smb.conf
chmod 644 /etc/samba/smb.conf
service smbd restart
service nmbd restart

#create /etc/ntp.conf
cat ntp.conf > /etc/ntp.conf
chmod 644 /etc/ntp.conf
service ntp restart

#create /etc/exim4/update-exim4.conf.conf
#set the correct hosname before update the configfile
hostname=$(hostname)
sed -i -e 20c"dc_other_hostnames='${hostname}.domainname.tld'" update-exim4.conf.conf
cat update-exim4.conf.conf > /etc/exim4/update-exim4.conf.conf
chmod 644 /etc/exim4/update-exim4.conf.conf

#config the unattendend-upgrade
cat 10periodic > /etc/apt/apt.conf.d/10periodic
sed -i '$aUnattended-Upgrade::Mail "<mailadresse>";' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i '$aUnattended-Upgrade::Automatic-Reboot "true";' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i '$aUnattended-Upgrade::Automatic-Reboot-Time "05:00";' /etc/apt/apt.conf.d/50unattended-upgrades
service unattended-upgrades restart

#correct the Showname of the User Root, Hostname ist set to UpperCases
hostname=$(hostname | tr [:lower:] [:upper:])
usermod -c "Root ${hostname}" root

#hinzufügen des MAILTO Eintrages in der Root Crontab
bash CronEdit.sh

#join Domain <REALM> (type "net ads leave -U administrator" to leave the domain)
joinstatus=$(net rpc testjoin)
good="Join to '<REALM>' is OK"

if [[ "$joinstatus" == "$good" ]];then
        echo $good
else
	net rpc join <REALM> -U administrator
fi

#create /etc/nsswitch.conf
cat nsswitch.conf > /etc/nsswitch.conf
chmod 644 /etc/nsswitch.conf

#restart winbind
service winbind restart

#correct mod of the Directory where the Data will be stored
chmod 777 /<directrory>

#create Directorys under <directrory>
#UserHomes
if ! [ -d "/<directrory>/UserHomes" ]; then
	mkdir /<directrory>/UserHomes
fi
chmod 777 /<directrory>/UserHomes
net conf showshare users > /dev/null
if [ $? != 0 ];then
	net conf addshare users /<directrory>/UserHomes writeable=y guest_ok=n "Home-Dirs"
	net conf setparm users "browsable" "no"
	net conf setparm users "create mask" "700"
	net conf setparm users "directory mask" "700"
fi

#UserProfiles
if ! [ -d "/<directrory>/UserProfiles" ]; then
	mkdir /<directrory>/UserProfiles
fi
chmod 1770 /<directrory>/UserProfiles
chgrp 'Domain Users' /<directrory>/UserProfiles
net conf showshare profile > /dev/null
if [ $? != 0 ];then
	net conf addshare profile /<directrory>/UserProfiles writeable=y guest_ok=n "User Profile"
	net conf setparm profile "browsable" "no"
	net conf setparm profile "profile acls" "yes"
fi

#Datenbereich
if ! [ -d "/<directrory>/daten" ]; then
	mkdir /<directrory>/daten
fi
chmod 777 /<directrory>/daten

#create acl temps for correct Subdirs from Old Servers
cat UH_facl.conf > /<directrory>/UserHomes/UH_facl.conf
cat UP_facl.conf > /<directrory>/UserProfiles/UP_facl.conf

#Hinweis auf die Anpassung der fstab um die optionen user_xattr,acl für die beiden Partitionen
echo ",user_xattr,acl noch als zusätzliche Option an die vorhandenen anhängen"
