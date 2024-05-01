#!/bin/bash

s3_bucket="abhijeettestingbucket22"
folder_to_copy="/home/acer/zipFolder"
recipient_email="abhijeet4rana@gmail.com"

current_dir=$(dirname "$0")

cd "$current_dir" || exit

script_files=$(find . -maxdepth 1 -type f -name "*.sh" -not -name "$(basename "$0")")

for script_file in $script_files; do
    if [ -x "$script_file" ]; then
        echo "Executing $script_file..."
        "./$script_file"
    else
        echo "Skipping $script_file as it is not executable."
    fi
done

aws s3 cp "$folder_to_copy" "s3://$s3_bucket/$folder_to_copy" --recursive

if [ $? -eq 0 ]; then
    echo "Upload to S3 successful. Sending email notification..."
    echo "Upload to S3 successful. Folder $folder_to_copy uploaded to s3://$s3_bucket/$folder_to_copy" | mail -s "S3 Upload Successful" "$recipient_email"
else
    echo "Upload to S3 failed."
fi
