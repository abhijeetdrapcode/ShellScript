#!/bin/bash

log_directory="/home/acer/.pm2/logs"
read -p "Enter the name of the log file (e.g., filename.log): " log_file_name
read -p "Enter the desired date (YYYY-MM-DD): " date
output_directory="/home/acer/coding/LogFileZip"


mkdir -p "$output_directory"


if [ ! -f "$log_directory/$log_file_name" ]; then
    echo "Specified log file does not exist."
    exit 1
fi


grep "$date" "$log_directory/$log_file_name" > "$output_directory/${date}-$log_file_name-logs.txt"


if [ -s "$output_directory/${date}-$log_file_name-logs.txt" ]; then

    gzip "$output_directory/${date}-$log_file_name-logs.txt"
    echo "Logs containing the specified date have been extracted and zipped successfully."
else
    echo "No logs found containing the specified date in the specified log file."

    rm -f "$output_directory/${date}-$log_file_name-logs.txt"
fi

