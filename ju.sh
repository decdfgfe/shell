#!/bin/bash
#Create Date:2017-09-21 22:08:41
#Modified Date:2017-09-21 22:12:04
#Author:wuyang
curl -s http://dict.cn/ |\
sed -n '/<div id="daily_sentence_v" class="daily_sentence">/,/<div class="ad_banner">/p' |\
sed -e 's/<[^>*]*>//g'  -e 's/[[:space:]]/ /g' |\
sed -e 's/[a-z]\+/&%/g' -e 's/\&nbsp%;/\n/g' -e 's/ //g' -e '/^$/d' -e 's/%/ /g'|\
sed -e '/^$/d' -e "1s/.*/$(date +%Y-%m-%d)/"
