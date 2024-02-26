#!/bin/bash

log_directory="/home/acer/.pm2/logs"
read -p "Enter the name of the log file (e.g., filename.log): " log_file_name
read -p "Enter the desired date (YYYY-MM-DD): " date
output_directory="/home/acer/coding/LogFileZip"

# if the directory does not exists it will create a new directory
mkdir -p "$output_directory"

#check and find the log files for specified date
log_files=$(find "$log_directory" -type f -name "*$date*")

if [ -z "$log_files" ]; then
    echo "No log files found for the specified date."
    exit 1
fi

#finding the data with the specified date that the user entered in the terminal
grep "$date" "$log_directory/$log_file_name" > "$output_directory/${date}-$log_file_name-logs.txt"

#zipping the log file if there is data for the specified date
gzip "$output_directory/${date}-$log_file_name-logs.txt"

echo "Logs containing the specified date have been extracted and zipped successfully."

