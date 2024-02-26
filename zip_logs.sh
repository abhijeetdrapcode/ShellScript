#!/bin/bash

log_directory="/home/acer/.pm2/logs"
read -p "Enter the name of the log file (e.g., filename.log): " log_file_name
read -p "Enter the desired date (YYYY-MM-DD): " date
output_directory="/home/acer/coding/LogFileZip"

# if the directory does not exists it will create a new directory
mkdir -p "$output_directory"

# Check and find the log file specified by the user
if [ ! -f "$log_directory/$log_file_name" ]; then
    echo "Specified log file does not exist."
    exit 1
fi

# Finding the data with the specified date in the user-specified log file
grep "$date" "$log_directory/$log_file_name" > "$output_directory/${date}-$log_file_name-logs.txt"

# Zipping the log file if there is data for the specified date
if [ -s "$output_directory/${date}-$log_file_name-logs.txt" ]; then
    gzip "$output_directory/${date}-$log_file_name-logs.txt"
    echo "Logs containing the specified date have been extracted and zipped successfully."
else
    echo "No logs found containing the specified date in the specified log file."
fi


