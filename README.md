# Automation_Project

Automation project by Abhishek Garg

Description:
This program updates all packages, checks if apache2 is installed and if not found to be installed then installs apache2 package. Program looks for the statuas of service apache2, if found not active then program starts the apache2 service.Simillarly program looks for enable/disable status of apache2, if found to be disabled then program enables the service apache. Now the program create the tar of .log files and stores the tar file in /tmp. aws cli is used to copy the tar file on amazon s3 bucket.

Infrastructure setup
-AWS EC2 instance with ubuntu AMI
-aws cli installed on server
-s3_bucket created with name upgrad-abhishek
-IAM role: Abhishek_CouseAssignment
-Git repository: https://github.com/abhisgar/Automation_Project.git

Usage:
-bash automation.sh
-./automation.sh


The Automation script performs the following funtions

1. Updates all packages
    apt update -y
    
2. Check and install apche2
    Check if apache2 is already installed, if not
    apt install apache2 -y
    
3. Check and start apache2 service
    Check if apache2 service is running, if not
    systemctl start apache2
    
4. Check and enable apache2 service
    Check if apache2 service is enabled, if not
    systemctl enable apache2
    
5. Tar the .log files to /tmp folder
6. Copy the tar file to s3 bucket "upgrad-abhishek"
7. Add the tar log in the inventory.htmls
    Check if inventory.html is present and append log, if not
    create inventory.hetml and append data.

8. Add a cron to run the automation.sh script daily at 1800hrs server time. 

