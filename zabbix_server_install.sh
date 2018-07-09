#!/bin/bash

#centos 7 install zabbix server 
. /etc/init.d/functions
setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config

info() {
	echo -e "\e[0;33m $* \e[0m"
}
warning() {
	echo -e "\e[0;31m $* \e[0m"
}

#checking ........ 
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 >/dev/null 2>&1
rpm -ivh http://repo.zabbix.com/zabbix/3.0/rhel/7/x86_64/zabbix-release-3.0-1.el7.noarch.rpm /dev/null 2>&1
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX >/dev/null 2>&1
#yum install epel-release.noarch wget vim gcc gcc-c++ lsof chrony tree nmap unzip rsync -y >/dev/null 2>&1
#yum install httpd mariadb mariadb-server mariadb-client php php-mysql -y >/dev/null 2>&1
#yum install zabbix-server-mysql zabbix-web-mysql zabbix-get zabbix-agent -y >/dev/null 2>&1




echo "----------------------"
info "Check Environment Start"
echo "----------------------"
for i in zabbix-server-mysql zabbix-web-mysql zabbix-get zabbix-agent \
	 epel-release wget vim gcc gcc-c++ lsof chrony tree nmap unzip rsync \
	 httpd mariadb mariadb-server  php php-mysql;do
	rpm -qa | grep $i -q
	if [ $? -eq 0 ];then
		action "$i installed" /bin/true
	else
		action "$i installed" /bin/false
		info "install $i ..."
		yum install -y $i >/dev/null 2>&1
		if [ $? -eq 0 ];then
			action "$i install" /bin/true
		else
			action "$i install" /bin/false
			warning "$i installed faild please check yum repostory"
			exit 1
		fi
	fi
done
echo "----------------------"
info "Check Environment Done"
echo "----------------------"


#create mysql PASSWORD
read -p "Please input Mysql root password:" password
info "Your Mysql root password is $password"
mysqladmin password $password

mysql -uroot -p$password -e "CREATE DATABASE zabbix DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;"
mysql -uroot -p$password -e "grant all privileges on zabbix.* to 'zabbix'@'%' identified by 'zabbix'"
zcat /usr/share/doc/zabbix-server-mysql-3.0.3/create.sql.gz | mysql -uzabbix -pzabbix zabbix

cat >/etc/zabbix/zabbix_server.conf<<EOF
LogFile=/var/log/zabbix/zabbix_server.log
LogFileSize=0
PidFile=/var/run/zabbix/zabbix_server.pid
DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=zabbix
SNMPTrapperFile=/var/log/snmptrap/snmptrap.log
Timeout=4
AlertScriptsPath=/usr/lib/zabbix/alertscripts
ExternalScripts=/usr/lib/zabbix/externalscripts
LogSlowQueries=3000
EOF


check_status() {
	if [ $? -eq 0 ];then
		action $1 /bin/true
	else
		action $1 /bin/false
	fi
}

systemctl start httpd  >/dev/null 2>&1
check_status httpd
systemctl start zabbix-server >/dev/null 2>&1
check_status zabbix-server
systemctl start zabbix-agent >/dev/null 2>&1
check_status zabbix-agent


info "Zabbix installed success,please check http://ip/zabbix"

