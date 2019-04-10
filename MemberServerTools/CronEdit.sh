#!/bin/bash
#fügt der SystemCrontab den Eintrag MAILTO hinzu
echo "MAILTO=<mailadress>" > tmp
crontab -l >> tmp
cat tmp | crontab - 
rm tmp
