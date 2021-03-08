#!/bin/bash

#Project code by Abhishek Garg
#Declaring variables

apache_status=`dpkg -l apache2 | tail -1 | awk '{print $1 }'`
apache_srv_status=`systemctl status apache2 | head -5 | tail -1 | awk '{ print $2 }'`
apache_rc=`systemctl status apache2 | head -2 | tail -1 | awk -F ';' '{ print $2 }'`
apache_rc_status=" enabled"
srv_status="active"
apc_status="ii"
timestamp=$(date '+%d%m%Y-%H%M%S')
myname="Abhishek"
s3_bucket="upgrad-abhishek"

echo -e "\n\n******HELLO!!! Welcome to the project execution !!!******"

#Updating all packages
echo -e "\n\n1. Updating all packages...."
apt update -y &> /dev/null
echo -e "\tUpdating all packages successfull "



echo -e "\n\n2. Checking if Apache2 is already installed..."
if [ "$apache_status" = "$apc_status" ]
then
	echo -e "\tApache2 is ALREADY INSTALLED, Check Passed..."
else
	echo -e "\tApache2 is not installed..."
	echo -e "\tInstalling apache2..."
	apt install apache2 -y &> /dev/null
	echo -e "\tApache2 installation: SUCCESS"
fi


echo -e "\n\n3. Check if service apache2 is running..."
if [ "$apache_srv_status" = "$srv_status" ]
then
	echo -e "\tApache2 service is ALREADY RUNNING & ACTIVE, Check Passed..."
else
	echo -e "\tApache2 service is inactive..."
	echo -e "\tStarting Apache2 service..."
	systemctl start apache2 >> /dev/null
	echo -e "\tapache2 service is now: " `systemctl status apache2 | head -5 | tail -1 | awk '{ print $2 }'`
fi


echo -e "\n\n4. Checking if Apache2 is enabled for auto start on reboot..."
if [ "$apache_rc" = "$apache_rc_status" ]
then
	echo -e "\tApache2 service is ALREADY ENABLED to auto start on reboot..."
else
	echo -e "\tApache2 is disbaled..."
	echo -e "\tEnabling Apache2 to auto start on reboot..."
	systemctl enable apache2 &> /dev/null
	echo -e "\tApache2 is now" `systemctl status apache2 | head -2 | tail -1 | awk -F ';' '{ print $2 }'`
fi


#Creating tar of log files present under /var/log/apache2 directory
echo -e "\n\n5. Creating tar of log files under apache2 directory & storing in /tmp"
tar -cf /tmp/$myname-httpd-logs-$timestamp.tar --absolute-names /var/log/apache2/*.log &>/dev/null
echo -e "\tTar file successfully created on /tmp location"


#Copying the tar archive on S3 bucket
echo -e "\n\n6. Copying tar archive file to S3 bucket"
aws s3 cp /tmp/$myname-httpd-logs-$timestamp.tar s3://$s3_bucket/$myname-httpd-logs-$timestamp.tar
echo -e "\tCopy to S3 bucket: SUCESS"


#Checking Inventory file and updating logs
logfile=`ls -ltr /tmp/*.tar | grep -i $timestamp | awk -F '/' '{print $3 }' | awk -F '-' '{print $2 "-" $3 }'`
fext=`ls -ltr /tmp | grep -i $timestamp | awk -F '.' '{print $2 }'`
fsize=`ls -ltrh /tmp/*.tar | grep -i $timestamp | awk '{ print $5 }'`
echo -e "\n\n7. Checking Inventory.html file and updating logs"
ls -ltr /var/www/html/inventory.html &> /dev/null
tmp=`echo $?`

if [ "$tmp" = "0" ]
then
        echo -e "\tInventory file already exists....check passed"
        echo -e "\tAdding logs to inventory.html file...."
	printf "$logfile\t\t$timestamp\t\t$fext\t\t$fsize\n" >> /var/www/html/inventory.html
	echo -e "\tLog added successfully!!!"
else
        echo -e "\tInventory.html doesnot Exist!!! Creating inventory file now...."
        printf "Log Type\t\tTime Created\t\tType\t\tSize\n" >> /var/www/html/inventory.html
        echo -e "\tInventory.html file created and header added"
	echo -e "\tAdding logs to inventory.html file...."
        printf "$logfile\t\t$timestamp\t\t$fext\t\t$fsize\n" >> /var/www/html/inventory.html
	echo -e "\tLog added successfully!!"
fi


#Checking if cron file exists, add entry if doesnt
echo -e "\n\n8. Creating cron file and adding the cron job"
ls -ltr /etc/cron.d/automation &> /dev/null
tmp1=`echo $?`

if [ "$tmp1" = "0" ]
then
	echo -e "\tCron file exists"
	jobprsnt=`cat /etc/cron.d/automation | grep -i automation | awk '{print $7 }' | awk -F '/' '{print $4}'`
	tmp2=`echo $?`
	if [ "$jobprsnt" = "automation.sh" ]
	then
		echo -e "\tJob is already scheduled"
	else
		echo -e "\tAdding job in file at it was not added already"
		echo -e "0 1 * * * root /root/Automation_Project/automation.sh" >> /etc/cron.d/automation
		echo -e "\tCron entry is added successfully !!!"
	fi
else
	echo -e "\tCron file doesnot exist!! Creating cron file now"
	touch /etc/cron.d/automation
	echo -e "\tAdding job in cron file"
	echo -e "0 1 * * * root /root/Automation_Project/automation.sh" >> /etc/cron.d/automation
	echo -e "\tCron entry is added successfully!!!"
fi

echo -e "\n\n\n******All Functions performed Successfully, Thank you!!******"
