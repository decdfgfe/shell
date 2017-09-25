#!/bin/bash
read -p "plz input the script name you want to check: " file
if [ -f $file ] ; then
	sh -n $file > /dev/null 2>&1;
	if [ $? -ne 0 ] ; then
	read -p "Script file $file  has syntax error,Type Q|q to exit or type any other key to edit ${file}: " answer
	case $answer in
		q | Q)
		exit 0
		;;
		*)
		vim $file
		;;
	esac
	else 
	echo "$file syntax is OK!"
	exit 0
	fi
else
	echo "$file not exists"
	exit 1

fi
		
	
