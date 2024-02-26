#!/bin/bash

log_directory="/home/acer/.pm2/logs"
read -p "Enter the name of the log file (e.g., filename.log): " log_file_name
read -p "Enter the desired date (YYYY-MM-DD): " date
output_directory="/home/acer/coding/LogFileZip"

# Ensure output directory exists
mkdir -p "$output_directory"

# Find log files for the specified date
log_files=$(find "$log_directory" -type f -name "*$date*")

if [ -z "$log_files" ]; then
    echo "No log files found for the specified date."
    exit 1
fi

# Search for logs containing the specified date in the specified log file
grep "$date" "$log_directory/$log_file_name" > "$output_directory/${date}-$log_file_name-logs.txt"

# Zip the log file
gzip "$output_directory/${date}-$log_file_name-logs.txt"

echo "Logs containing the specified date have been extracted and zipped successfully."

