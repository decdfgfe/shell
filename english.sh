#!/bin/bash
#Create Date:2017-09-21 22:08:41
#Modified Date:2017-09-21 22:12:04
#Author:wuyang
#description:dict.cn everyday sentence and translate the word you want 
sentence(){
curl -s http://dict.cn/ |\
sed -n '/<div id="daily_sentence_v" class="daily_sentence">/,/<div class="ad_banner">/p' |\
sed -e 's/<[^>*]*>//g'  -e 's/[[:space:]]/ /g' |\
sed -e 's/[a-z]\+/&%/g' -e 's/\&nbsp%;/\n/g' -e 's/ //g' -e '/^$/d' -e 's/%/ /g'|\
sed -e '/^$/d' -e "1s/.*/$(date +%Y-%m-%d)/"
}
translate(){
echo "detail of word ${1}:"
curl -s "http://dict.cn/$1"|\
sed -n '/<div class="word-cont">/,/<div id="dshared">/p'|\
#sed -n '/<div class="layout detail">/,/<div class="section sent">/p'|\
sed -e 's/<[^>*]*>//g' -e 's/[[:space:]]/ /g'|\
#sed -e 's/<[^>*]*>//g' -e 's/[[:space:]]/ /g'|\
sed '/^$/d' |\
sed -e 's/]/]\t/' -e 's/[a-z]\{1,\}\./\n&/g' -e 's/[a-z]\+/&%/g' -e 's/[[:space:]]//g' |\
sed '/^$/d' | sed -e 's/%/ /g'  -e '/if (less 1280){*/d' -e '/document .write*/d' -e '/}else {/d' -e '/}/d'| more
}
noword(){
	echo "no such word"
}

help(){
echo -e "Usage:`basename $0` [option] [file]\n"
echo -e "-h --help print help info\n"
echo -e "-w --word translate the word you input. default option\n"
echo -e "-s --sentense print daily sentense\n"
}
if [ -z "$1" ];then
sentence
fi
if [ "$#" -eq 1 ];then
	case "$1" in
		-h|--help)
		help
		;;
		*)
		length=`translate $1 | wc -l`
		if [[ "$length" -ne 1 ]];then
			translate $1
		else
			noword
			exit 0
		fi
		;;
	esac
fi
	
if [ "$#" -eq 2 ];then
	case "$1" in
		-h|--help)
		help
		;;
		-s|--sentence)
		sentence
		;;
		-w|--word)
		length=`translate $2 | wc -l`
		if [[ "$length" -ne 1 ]];then
			translate $2
		else
			noword
			exit 0
		fi
		;;
		*)
		echo "something went wrong,check your input."
		help
		exit 1
		;;
	esac
fi
