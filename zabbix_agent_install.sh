#!/bin/bash
#Centos 7 install zabbix agent
. /etc/init.d/functions
valid_ip(){
    local ip=$1
    local stat=1
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return ${stat}
}

info(){
	echo -e "\033[33m $* \033[0m"
}
warning(){
	echo -e "\033[31m $* \033[0m"
}


while true;do
read -p "Please Input Zabbix server's ipaddress:" ipaddress
valid_ip $ipaddress
if [ $? -eq 0 ];then
	echo "-------------------------------------"
	info "zabbix server ipaddress is $ipaddress"
	info "Start Install zabbix agent..."
	echo "-------------------------------------"
	break
else
	warning "Ipaddress not valid,please Enter Correct IPaddress"
fi
done


rpm -qa | grep zabbix-agent -q 
if [ $? -ne 0 ];then
rpm -ivh http://repo.zabbix.com/zabbix/3.0/rhel/7/x86_64/zabbix-release-3.0-1.el7.noarch.rpm >/dev/null 2>&1
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 >/dev/null 2>&1
yum install zabbix-agent -y >/dev/null 2>&1
fi
rpm -qa | grep zabbix-agent -q 

if [ $? -eq 0 ];then
	action "Zabbix agent installed" /bin/true
else 
	action "Zabbix-agent installed faild" /bin/false
	exit 1
fi
cat >/etc/zabbix/zabbix_agentd.conf <<EOF
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
Server=$ipaddress
ServerActive=$ipaddress
Hostname=zabbix_host
Include=/etc/zabbix/zabbix_agentd.d/
EOF

service zabbix-agent restart >/dev/null 2>&1

ps aux | grep  zabbix-agentd -q

if [ $? -eq 0 ];then
	action "Zabbix agent service started" /bin/true
	echo "------------------------------------------"
	info "Zabbix Agent installed and started running"
	echo "------------------------------------------"
fi
