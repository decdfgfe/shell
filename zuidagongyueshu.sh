#!/bin/bash
Usage(){
	echo "Usage:`basename $0` Number1 Number2"
	exit 1
}
if [ "$#" -ne 2 ];then
	Usage;
fi
Max_common_divisor(){
	if [ "$2" -eq 0 ];then
	#echo "Max common divisor is $1"
	echo $1
	else
	Max_common_divisor $2 $(($1%$2))
	fi
}
temp=$(Max_common_divisor $1 $2)
echo "The least common multiple is $(($1*$2/$temp))"
echo "The max common divisor is $temp"
