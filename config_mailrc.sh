#!/bin/bash
#####################################################################
#             linux mail.rc configure script                        #
#all your email shoud oepen smtp			            #
#gmail please go to https://myaccount.google.com/lesssecureapps     #
#####################################################################
info(){
	echo -e "\033[31m$*\033[0m"
}
cat <<eof
1. smtp.exmail.qq.com
2. smtp.gmail.com
3. smtp.126.com
4. smtp.qq.com
eof
read -p "please input 1 or 2 or 3:" select
case "$select" in
	1) smtp=smtp.exmail.qq.com
	;;
	2) smtp=smtp.gmail.com
	;;
	3) smtp=smtp.126.com
	;;
	4) smtp=smtp.qq.com
	*) echo 'plz input 1 or 2 or 3 or 4'
	exit 1
	;;
esac
echo "$smtp"
read -p "please input port,default is 465:" port
if [ -z "$port" ];then
	port=465
fi
echo "use smtp port:"$port
mkdir -p /root/.certs/
echo -n | openssl s_client -connect ${smpt}:${port} | sed -ne '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/p' > ~/.certs/${smtp}.crt
certutil -A -n "GeoTrust SSL CA" -t "C,," -d ~/.certs -i ~/.certs/${smtp}.crt
certutil -A -n "GeoTrust Global CA" -t "C,," -d ~/.certs -i ~/.certs/${smtp}.crt
certutil -L -d /root/.certs
if [ -f "/etc/mail.rc" ];then
mv /etc/mail.rc /etc/mail.rc.bak$$
else
touch /etc/mail.rc
fi

read -p "please input email address:" email
read -p "please input email password:" password


cat >/etc/mail.rc<<EOF
set hold
set append
set ask
set crt
set dot
set keep
set emptybox
set indentprefix="> "
set quote
set sendcharsets=iso-8859-1,utf-8
set showname
set showto
set newmail=nopoll
set autocollapse
ignore received in-reply-to message-id references
ignore mime-version content-transfer-encoding
fwdretain subject date from to
set bsdcompat
set ssl-verify=ignore
set nss-config-dir=/root/.certs
#set nss-config-dir=/etc/pki/nssdb/
set from=${email} smtp=smtps://${smtp}:${port}
set smtp-auth-user="$email" smtp-auth-password="$password"
set smtp-auth=login
EOF
echo "`date`"| mail -s "mail.rc configure test" $email
if [ $? -eq 0 ];then
info "linux mailrc configured success"
fi

