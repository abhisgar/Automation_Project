#!/bin/bash

#apache_status=`apt list apache2 | tail -1 | awk '{print $4 }'`
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
echo -e "\n\n\n\t\t\t******All Functions performed Successfully, Thank you!!******"

