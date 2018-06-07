#!/bin/bash

#use AWS CLI
aws configure

#ask user for their key pair name
read -p 'Key Pair Name: ' keyname
read -p 'Key Pair PEM Path (leaving off the final slash): ' keypath
read -p 'Security Group: ' securitygroup

#launch an Ubuntu 16.04 EC2 instance
aws ec2 run-instances --image-id ami-a4dc46db --count 1 --instance-type t2.micro --key-name $keyname --security-groups $securitygroup

#ask user for Public DNS of newly created EC2 instance
read -p 'Public DNS of new instance: ' ec2dns

#ssh into the new EC2 instance to execute remote commands
ssh -i $keypath/$keyname.pem ubuntu@$ec2dns 'sudo apt-get update -y && sudo apt-get upgrade -y; sudo apt-get install apache2 -y; sudo systemctl start apache2; sudo groupadd www; sudo usermod -a -G www ubuntu; sudo chown -R root:www /var/www; sudo chmod 2775 /var/www; sudo find /var/www -type d -exec chmod 2775 {} +; sudo find /var/www -type f -exec chmod 0664 {} +; echo "Hello, World!" > /var/www/html/index.html'