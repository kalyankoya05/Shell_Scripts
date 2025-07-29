#!/bin/bash

####################
# This script will list all the resources in the AWS account
# Author : Kalyan
# Date : 29-07-2025
# Version : V1
# This script will report the AWS resource usage
####################

# Following are the Supported AWS Services by this script:
# AWS S3
# AWS EC2
# AWS Lambda
# AWS IAM Users
# EBS
# AWS RDS
# AWS CloudWatch
# AWS VPC
# AWS CloudFormation
# AWS SNS
# AWS SQS
# AWS CloudTrail
# AWS Route 53
# AWS CloudFront

set -x # Debug mode
set -e # Exit on error
set -o # pipefail

# usage : ./aws.sh <region> <resource_type>
# Example: ./aws.sh us-east-1 s3
# Check if the required arguments are provided

# Check if the required arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <region> <resource_type>"
    exit 1
fi

# Check if the AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install it first."
    exit 1
fi

# Check if the AWS CLI is configured
if ! aws sts get-caller-identity &> /dev/null; then
    echo "AWS CLI is not configured. Please configure it using 'aws configure'."
    exit 1
fi

# Check if the provided region is valid
if ! aws ec2 describe-regions --region $1 &> /dev/null; then
    echo "Invalid AWS region: $1"
    echo "Please provide a valid AWS region."
    exit 1
fi

# Check if the provided resource type is valid
VALID_RESOURCE_TYPES=("s3" "ec2" "lambda" "iam" "ebs" "rds" "cloudwatch" "vpc" "cloudformation" "sns" "sqs" "cloudtrail" "route53" "cloudfront")
if [[ ! " ${VALID_RESOURCE_TYPES[@]} " =~ " $2 " ]]; then
    echo "Invalid resource type: $2"
    echo "Supported resource types: ${VALID_RESOURCE_TYPES[*]}"
    exit 1
fi

# Set the AWS region
AWS_REGION=$1
RESOURCE_TYPE=$2

# Set the AWS region for the CLI
aws configure set region $AWS_REGION

# Function to list S3 buckets
list_s3_buckets() {
    echo "Listing S3 Buckets in region $AWS_REGION:"
    aws s3 ls
}

# Function to list EC2 instances
list_ec2_instances() {
    echo "Listing EC2 Instances in region $AWS_REGION:"
    aws ec2 describe-instances --query "Reservations[].Instances[].InstanceId" --output text
}

# Function to list Lambda functions
list_lambda_functions() {
    echo "Listing Lambda Functions in region $AWS_REGION:"
    aws lambda list-functions --query "Functions[].FunctionName" --output text
}

# Function to list IAM users
list_iam_users() {
    echo "Listing IAM Users in region $AWS_REGION:"
    aws iam list-users --query "Users[].UserName" --output text
}

# Function to list EBS volumes
list_ebs_volumes() {
    echo "Listing EBS Volumes in region $AWS_REGION:"
    aws ec2 describe-volumes --query "Volumes[].VolumeId" --output text
}

# Function to list RDS instances
list_rds_instances() {
    echo "Listing RDS Instances in region $AWS_REGION:"
    aws rds describe-db-instances --query "DBInstances[].DBInstanceIdentifier" --output text
}

# Function to list CloudWatch metrics
list_cloudwatch_metrics() {
    echo "Listing CloudWatch Metrics in region $AWS_REGION:"
    aws cloudwatch list-metrics --query "Metrics[].MetricName" --output text
}

# Function to list VPCs
list_vpcs() {
    echo "Listing VPCs in region $AWS_REGION:"
    aws ec2 describe-vpcs --query "Vpcs[].VpcId" --output text
}

# Function to list CloudFormation stacks
list_cloudformation_stacks() {
    echo "Listing CloudFormation Stacks in region $AWS_REGION:"
    aws cloudformation describe-stacks --query "Stacks[].StackName" --output text
}

# Function to list SNS topics
list_sns_topics() {
    echo "Listing SNS Topics in region $AWS_REGION:"
    aws sns list-topics --query "Topics[].TopicArn" --output text
}

# Function to list SQS queues
list_sqs_queues() {
    echo "Listing SQS Queues in region $AWS_REGION:"
    aws sqs list-queues --query "QueueUrls[]" --output text
}

# Function to list CloudTrail trails
list_cloudtrail_trails() {
    echo "Listing CloudTrail Trails in region $AWS_REGION:"
    aws cloudtrail describe-trails --query "trailList[].Name" --output text
}

# Function to list Route 53 hosted zones
list_route53_zones() {
    echo "Listing Route 53 Hosted Zones in region $AWS_REGION:"
    aws route53 list-hosted-zones --query "HostedZones[].Name" --output text
}

# Function to list CloudFront distributions
list_cloudfront_distributions() {
    echo "Listing CloudFront Distributions in region $AWS_REGION:"
    aws cloudfront list-distributions --query "DistributionList.Items[].Id" --output text
}

# Execute the appropriate function based on the resource type
case $RESOURCE_TYPE in
    s3)
        list_s3_buckets
        ;;
    ec2)
        list_ec2_instances
        ;;
    lambda)
        list_lambda_functions
        ;;
    iam)
        list_iam_users
        ;;
    ebs)
        list_ebs_volumes
        ;;
    rds)
        list_rds_instances
        ;;
    cloudwatch)
        list_cloudwatch_metrics
        ;;
    vpc)
        list_vpcs
        ;;
    cloudformation)
        list_cloudformation_stacks
        ;;
    sns)
        list_sns_topics
        ;;
    sqs)
        list_sqs_queues
        ;;
    cloudtrail)
        list_cloudtrail_trails
        ;;
    route53)
        list_route53_zones
        ;;
    cloudfront)
        list_cloudfront_distributions
        ;;
    *)
        echo "Unsupported resource type: $RESOURCE_TYPE"
        echo "Supported resource types: s3, ec2, lambda, iam, ebs, rds, cloudwatch, vpc, cloudformation, sns, sqs, cloudtrail, route53, cloudfront"
        exit 1
        ;;
esac
