logfile="httpd-logs"

#Checking Inventory file and updating logs
fext=`ls -ltr /tmp | tail -1 | awk -F '.' '{print $2 }'`
fsize=`ls -ltrh /tmp/*.tar | tail -1 | awk '{ print $5 }'`
echo -e "\n\n7. Checking Inventory.html file and updating logs"
ls -ltr /var/www/html/inventory.html &> /dev/null
tmp=`echo $?`

if [ "$tmp" = "0" ]
then
	echo -e "\tInventory file already exists....check passed"
	echo -e "\tAdding logs to inventory.html file...."
else
	echo -e "\tInventory.html doesnot Exist!!! Creating inventory file now...."
	echo -e "Log Type\t\tTime Created\t\tType\t\tSize" >> /var/www/html/inventory.html
	echo -e "\tInventory.html file created and header added"
	echo -e "$logfile\t\t$fext\t\t$fsize" >> /var/www/html/inventory.html
fi
