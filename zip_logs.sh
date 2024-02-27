#!/bin/bash

log_directory="/home/acer/.pm2/logs"
read -p "Enter the name of the log file (filename.log): " log_file_name
read -p "Enter the date you want the logs for (YYYY-MM-DD): " date
output_directory="/home/acer/coding/LogFileZip"


mkdir -p "$output_directory"


if [ ! -f "$log_directory/$log_file_name" ]; then
    echo "No Such file exists!"
    exit 1
fi


grep "$date" "$log_directory/$log_file_name" > "$output_directory/${date}-$log_file_name-logs.txt"


if [ -s "$output_directory/${date}-$log_file_name-logs.txt" ]; then

    gzip "$output_directory/${date}-$log_file_name-logs.txt"
    echo "Logs containing the specified date have been extracted and zipped successfully."
else
    echo "There are no logs for the date that you have entered in the log file"

    rm -f "$output_directory/${date}-$log_file_name-logs.txt"
fi

