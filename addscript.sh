#!/bin/bash
if [[ -z "$1" ]];then
	echo "Usage $0 [filename]"
	exit -1
else
	filename=$1;
fi
if ! grep "^#!" $filename &>/dev/null ;then
cat<<EOF>$filename
#!/bin/bash
#Create Date:`date +"%F %H:%M:%S"`
#Author:wuyang
EOF
else 
	sed -i "3i #Modified Date:`date +'%F %H:%M:%S'`" $filename
fi
vim $1
