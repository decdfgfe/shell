#!/bin/bash
#mail.rc shoud configured success before this script run
#mail.rc configure see configure_mailrc.sh
warningNo=95
sendmail(){
        local email="username@email.com" #change email to your mail.rc configured
        local message=$1
	local df=$(df -TH)
        local subject="Vultr Disk Usage Warning"
        echo -e "$message \n $df"| mail -s "$subject" $email
}
result=$(df -TH| awk '{if (NR !=1){ print $6}}'|awk -F% '{if($1>"'$warningNo'"){print "Disk usage warning:",$1}}')
if [ -n "$result" ];then
sendmail "$result"
fi
