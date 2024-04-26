#!/bin/bash

# Set S3 bucket name and folder to copy
s3_bucket="abhijeettestingbucket22"
folder_to_copy="/home/acer/zipFolder"

# Get the current directory
current_dir=$(dirname "$0")

# Change to the current directory
cd "$current_dir" || exit

# Find all shell script files in the current directory, excluding the script itself
script_files=$(find . -maxdepth 1 -type f -name "*.sh" -not -name "$(basename "$0")")

# Loop through each script file and execute it
for script_file in $script_files; do
    # Check if the file is executable
    if [ -x "$script_file" ]; then
        echo "Executing $script_file..."
        # Execute the script file
        "./$script_file"
    else
        echo "Skipping $script_file as it is not executable."
    fi
done

# Copy folder to S3 bucket
aws s3 cp "$folder_to_copy" "s3://$s3_bucket/$folder_to_copy" --recursive
