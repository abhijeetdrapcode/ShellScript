#!/bin/bash

log_directory="/home/acer/.pm2/logs"
read -p "Enter the desired date (YYYY-MM-DD): " date
output_directory="/home/acer/coding/LogFileZip"

mkdir -p "$output_directory"

log_files=$(find "$log_directory" -type f)

if [ -z "$log_files" ]; then
    echo "No log files found in the specified directory."
    exit 1
fi

for log_file in $log_files; do
    grep "$date" "$log_file" > "$output_directory/${date}-$(basename "$log_file")-logs.txt"
    
    if [ -s "$output_directory/${date}-$(basename "$log_file")-logs.txt" ]; then
        
        gzip "$output_directory/${date}-$(basename "$log_file")-logs.txt"
        echo "Logs containing the specified date from $(basename "$log_file") have been extracted and zipped successfully."
    else
        
        rm -f "$output_directory/${date}-$(basename "$log_file")-logs.txt"
    fi
done
