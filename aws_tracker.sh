#!/bin/bash

####################
# Author : Kalyan
# Date : 29-07-2025
# Version : V1
#
# This script will report the aws resource usage
####################

# AWS S3 
# AWS EC2
# AWS Lambda
# AWS IAM USers

set -x #Debug mode
set -e # Exit on error
set -o #pipefail

#list s3 buckets
echo "List buckets"
aws s3 ls


#list ec2 instances
echo "List EC2 Instances"
aws ec2 describe-instances
aws ec2 describe-instances | jq '.Reservations[].Instances[].InstanceId'


#list lambda functions
echo "List Lambda functions"
aws lambda list-functions


#list iam users
echo "List IAM Users"
aws iam list-users

