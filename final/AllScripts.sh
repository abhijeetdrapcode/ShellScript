#!/bin/bash

s3_bucket="abhijeettestingbucket23"
today_date=$(date +"%d-%m-%Y")
folder_to_copy="/home/acer/$today_date"

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

aws s3 cp "$folder_to_copy" "s3://$s3_bucket/$today_date" --recursive


if [ $? -eq 0 ]; then
    echo "Files successfully copied to S3. Deleting local files to save space..."
    rm -rf "$folder_to_copy"
else
    echo "Failed to copy files to S3. Local files are not deleted."
fi
