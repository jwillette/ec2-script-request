#!/bin/bash

#use AWS CLI
aws configure

#ask user for their key pair name
read -p 'Key Pair Name: ' keyname
read -p 'Security Group: ' securitygroup

#launch an Ubuntu 16.04 EC2 instance
aws ec2 run-instances --image-id ami-a4dc46db --count 1 --instance-type t2.micro --key-name $keyname --security-groups $securitygroup  --user-data file://AutoConfig.txt