# Automation_Project

Automation project by Abhishek Garg

The Automation script performs the following funtions

On execution this script updates the pacakges using apt module and performing update using apt update -y.
Once packages are updated, this script will install apache2 package using apt module. Command used is "apt install apache2 -y". If the package is already installed then it will pass saying package is already at latest version.
After apache2 installation, We are starting the apache2 servervice.
Also we are enabling the service after strting it, so that the service is started everytime on server start.
Script is pronting the complete status of apache start, enable and service status.
Once apache is running successfully, the script is creating the backup of .log files present under /var/log/apache2 location and storing under /tmp as .tar format with timestamp.
Now the script is pushing the .tar backup file on amazon s3 bucket upgrad-abhishek

