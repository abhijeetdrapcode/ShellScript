#!/bin/bash

log_directory="/home/acer/.pm2/logs"
current_date=$(date +"%Y-%m-%d")
zip_folder=$(date +"%d-%m-%Y")
output_directory="/home/acer/coding/LogFileZip/$zip_folder"
zip_directory="/home/acer/coding/LogFileZip"
zip_file="$zip_directory/logs-$zip_folder.zip"


mkdir -p "$output_directory"

log_files=$(find "$log_directory" -type f)

if [ -z "$log_files" ]; then
    echo "There are no log files in the log folder."
    exit 1
fi

for log_file in $log_files; do
    grep "$current_date" "$log_file" > "$output_directory/${current_date}-$(basename "$log_file")-logs.txt"
    
    if [ -s "$output_directory/${current_date}-$(basename "$log_file")-logs.txt" ]; then
        echo "Logs containing the current date from $(basename "$log_file") have been extracted successfully."
    else
        rm -f "$output_directory/${current_date}-$(basename "$log_file")-logs.txt"
    fi
done

zip -j "$zip_file" "$output_directory"/*
rm -r "$output_directory"
echo "Logs for the current date have been zipped into $zip_file."
