#!/bin/bash

#guess.sh: A game to guess the Random number,You can select the level 1, 2, 3
#
#


info() {
	echo -e "\033[32m$*\033[0m"
}
warning() {
	echo -e "\033[31m$*\033[0m"
}
if [ -z "$1" ];then
	LEVEL=2
	info "Your Level is Default 2"
else
	case "$1" in
		*[!1-9]*	)
			echo "Usage:`basename $0` levelnumber"
			exit 1
		;;
		*	)
		LEVEL=$1
		echo "Your Lever is $LEVEL"
		;;
	esac
fi
		


NUMBER=$RANDOM
LEN=${#NUMBER}
if [ $LEN -gt $LEVEL ];then
	NUMBER=$(echo $NUMBER | cut -c1-${LEVEL})
fi
	

while true;do
	read -p "input your number:" number
		case "$number" in
			*[!0-9]*	)
			warning "Not a Valid number\!"
			;;

			*)
			if [ $number -gt $NUMBER ] ;then
				echo "Guess Lower"
			elif [ $number -lt $NUMBER ];then
				echo "Guess Higher ";
			elif [ $number -eq $NUMBER ];then
				info "Bingo, You got it,the number is $number"
				break
			fi
			;;
		esac
done
