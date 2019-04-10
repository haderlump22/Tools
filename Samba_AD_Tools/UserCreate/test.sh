SERVER="banane"
USER="rachel"

if [ $SERVER == "NULL" ]
then
	echo "gleich NULL"
else
	UNCPROFIL="--profile-path=\\\\$SERVER\\profile\\$USER"
        UNCUSER="--home-drive=H: --home-directory=\\\\$SERVER\\users\\$USER"

	echo $UNCPROFIL
	echo $UNCUSER
fi
