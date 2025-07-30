#!/bin/bash

####################
# Author     : Kalyan
# Date       : 30-07-2025
# Description: Automate the creation of a complete AWS VPC setup using AWS CLI
#
# Prerequisites:
# - AWS CLI must be installed and configured
#
# Actions Performed by This Script:
# 1. Verify AWS CLI installation and credentials
# 2. Create a VPC
# 3. Create public and private subnets
# 4. Assign subnets to the VPC
# 5. Create and attach an Internet Gateway to the VPC
# 6. Create a Route Table
# 7. Associate Route Table with the public subnet
# 8. Add route to the internet
####################

set -e
set -o pipefail

# Step 1: Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI is not installed. Please install it first."
    exit 1
fi

# Step 2: Check AWS CLI configuration
if ! aws sts get-caller-identity &> /dev/null; then
    echo "❌ AWS CLI is not configured. Please configure it using 'aws configure'."
    exit 1
fi

# Step 3: Create VPC
VPC_ID=$(aws ec2 create-vpc \
    --cidr-block 10.0.0.0/16 \
    --query 'Vpc.VpcId' \
    --output text)
echo "✅ Created VPC: $VPC_ID"

aws ec2 create-tags --resources "$VPC_ID" --tags Key=Name,Value="MyVPC"

# Step 4: Create public subnet
PUBLIC_SUBNET_ID=$(aws ec2 create-subnet \
    --vpc-id "$VPC_ID" \
    --cidr-block 10.0.1.0/24 \
    --availability-zone us-east-1a \
    --query 'Subnet.SubnetId' \
    --output text)
echo "✅ Created public subnet: $PUBLIC_SUBNET_ID"

aws ec2 create-tags --resources "$PUBLIC_SUBNET_ID" --tags Key=Name,Value="MyPublicSubnet"

# Step 5: Create private subnet
PRIVATE_SUBNET_ID=$(aws ec2 create-subnet \
    --vpc-id "$VPC_ID" \
    --cidr-block 10.1.0.0/24 \
    --availability-zone us-east-1a \
    --query 'Subnet.SubnetId' \
    --output text)
echo "✅ Created private subnet: $PRIVATE_SUBNET_ID"

aws ec2 create-tags --resources "$PRIVATE_SUBNET_ID" --tags Key=Name,Value="MyPrivateSubnet"

# Step 6: Create Internet Gateway
INTERNET_GATEWAY_ID=$(aws ec2 create-internet-gateway \
    --query 'InternetGateway.InternetGatewayId' \
    --output text)
echo "✅ Created Internet Gateway: $INTERNET_GATEWAY_ID"

aws ec2 attach-internet-gateway \
    --vpc-id "$VPC_ID" \
    --internet-gateway-id "$INTERNET_GATEWAY_ID"

# Step 7: Create Route Table
ROUTE_TABLE_ID=$(aws ec2 create-route-table \
    --vpc-id "$VPC_ID" \
    --query 'RouteTable.RouteTableId' \
    --output text)
echo "✅ Created Route Table: $ROUTE_TABLE_ID"

aws ec2 create-tags --resources "$ROUTE_TABLE_ID" --tags Key=Name,Value="MyRouteTable"

# Step 8: Create route to internet
aws ec2 create-route \
    --route-table-id "$ROUTE_TABLE_ID" \
    --destination-cidr-block 0.0.0.0/0 \
    --gateway-id "$INTERNET_GATEWAY_ID"
echo "🌍 Added internet route to Route Table"

# Step 9: Associate Route Table with public subnet
aws ec2 associate-route-table \
    --subnet-id "$PUBLIC_SUBNET_ID" \
    --route-table-id "$ROUTE_TABLE_ID"
echo "✅ Associated Route Table with public subnet"

echo "🎉 VPC setup completed successfully!"
exit 0
# End of script
