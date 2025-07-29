#!/bin/bash

#################################
# Author : Kalyan
# Date : 10/10/2025
#
# This scripts the node health
#
# version v1
##################################

set -x # debug mode
set -e # exit on error
set -o pipefail


echo "Print disc space"
df -h



echo "proceses"
# free -h
ps -ef


echo "CPU's"
nproc


ps -ef |grep kalyan.k |awk -F" " '{print $2}'
