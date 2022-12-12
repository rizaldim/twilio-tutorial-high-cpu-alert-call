#!/bin/bash

# This script will:
# 1. Create a new key pair named MyKeyPair and save the key pair into MyKeyPair.pem file
# 2. Create a new security group called my-sg
# 3. Create ingress rule for my-sg security group to allow ssh connection from anywhere
# 4. Create an EC2 instance using my-sg security group and MyKeyPair key pair

aws ec2 create-key-pair \
    --key-name MyKeyPair \
    --query 'KeyMaterial' \
    --output text \
    > MyKeyPair.pem

chmod 400 MyKeyPair.pem

vpc_id=$(aws ec2 describe-vpcs \
    --query 'Vpcs[?IsDefault==`true`].VpcId | [0]' \
    --output text)

aws ec2 create-security-group \
    --group-name my-sg \
    --description "My security group" \
    --vpc-id $vpc_id

sec_group_id=$(aws ec2 describe-security-groups \
    --group-names my-sg \
    --query 'SecurityGroups[?GroupName==`my-sg`].GroupId | [0]' \
    --output text)

aws ec2 authorize-security-group-ingress \
    --group-id $sec_group_id \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

aws ec2 run-instances \
    --image-id ami-08c40ec9ead489470 \
    --instance-type t3.micro \
    --key-name MyKeyPair \
    --security-group-ids $sec_group_id
