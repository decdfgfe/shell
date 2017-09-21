#!/bin/bash
translate(){
if [ -z "$1" ];then
echo "Usage `basename $0` word";
exit 1
fi
echo "${1}:"
curl -s "http://dict.cn/$1"|\
sed -n '/<div class="word-cont">/,/<div id="dshared">/p'|\
#sed -n '/<div class="layout detail">/,/<div class="section sent">/p'|\
sed -e 's/<[^>*]*>//g' -e 's/[[:space:]]/ /g'|\
#sed -e 's/<[^>*]*>//g' -e 's/[[:space:]]/ /g'|\
sed '/^$/d' |\
sed -e 's/]/]\t/' -e 's/[a-z]\{1,\}\./\n&/g' -e 's/[a-z]\+/&%/g' -e 's/[[:space:]]//g' |\
sed '/^$/d' | sed -e 's/%/ /g'  -e '/if (less 1280){*/d' -e '/document .write*/d' -e '/}else {/d' -e '/}/d'| more
}
translate $1
