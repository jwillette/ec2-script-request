#!/bin/bash

#use AWS CLI
aws configure

#ask user for their key pair name
read -p 'Key Pair Name: ' keyname
read -p 'Key Pair PEM Path: ' keypath
read -p 'Security Group: ' securitygroup

#launch an Ubuntu 16.04 EC2 instance
aws ec2 run-instances --image-id ami-a4dc46db --count 1 --instance-type t2.micro --key-name $keyname --security-groups $securitygroup

#ask user for Public DNS of newly created EC2 instance
read -p 'Public DNS of new instance: ' ec2dns

#ssh into the new EC2 instance to execute remote commands
ssh -i $keypath/$keyname.pem ubuntu@$ec2dns

#install operating system updates
sudo apt-get update && sudo apt-get upgrade

#install apache
sudo apt-get install "Apache Secure" -y

#create a group and add the ubuntu user to it
groupadd www
usermod -a -G www ubuntu
chown -R root:www /var/www

#change the directory permissions of /var/www and its subdirectories to add group write permissions and set the group ID on subdirectories created in the future
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} +

#recursively change the permissions for files in the /var/www directory and its subdirectories to add group write permissions
find /var/www -type f -exec chmod 0664 {} +

# set Apache's index.html file to display the text "Hello, World!"
echo "Hello, World!" > /var/www/html/index.html

#ensure apache is on
sudo systemctl start apache2 && sudo systemctl enable apache2