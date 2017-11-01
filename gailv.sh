#!/bin/bash
PIPS=2
MAXTHROW=1000
HEADS=0
TAILS=0
throw=0
print_result(){
	echo
	echo "HEADS=$HEADS"
	echo "TAILS=$TAILS"
	#persent=$(echo "scale=3;3/5"|bc)	
	persentHead=$(echo "scale=3;$HEADS/$MAXTHROW*100"|bc)
	persentTail=$(echo "scale=3;$TAILS/$MAXTHROW*100"|bc)
	echo "Persent of Heads:"$persentHead%;
	echo "Persent of Tails:"$persentTail%;
	echo

}

update_count(){
	case "$1" in
	0)	((HEADS++));;
	1)	((TAILS++));;
	esac
}


while [ "$throw" -lt "$MAXTHROW" ];do
	let "result = $RANDOM % $PIPS"
	update_count $result
	let "throw += 1"


done
print_result
exit $? 
