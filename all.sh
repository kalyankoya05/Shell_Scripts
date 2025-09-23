#!/bin/bash

# Open all further output in one file
# exec > all_output.txt 2>&1

# Create a Directory
# mkdir kalyan

# change to the directory and create files
cd kalyan
touch file1.txt file2.txt file3.txt

# List files in the current directory
ls -l

# Print name
echo "Koya Kalyan"

# Print numbers from 1 to 10
for i in {1..10}; do
  echo "$i"
done
