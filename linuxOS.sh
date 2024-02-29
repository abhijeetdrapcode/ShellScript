#!/bin/bash

log_file="/var/log/syslog"
current_date=$(date +"%b %d") 
zip_folder=$(date +"%d-%m-%Y")
output_directory="/home/acer/coding/LogFileZip/$zip_folder"
zip_directory="/home/acer/coding/LogFileZip"
zip_file="$zip_directory/logs-$zip_folder.zip"

mkdir -p "$output_directory"

if [ ! -f "$log_file" ]; then
    echo "The log file $log_file does not exist."
    exit 1
fi

grep "$current_date" "$log_file" > "$output_directory/${current_date}-syslog-logs.txt"

if [ -s "$output_directory/${current_date}-syslog-logs.txt" ]; then
    echo "Logs containing the current date from syslog have been extracted successfully."
else
    rm -f "$output_directory/${current_date}-syslog-logs.txt"
    echo "No logs containing the current date found in syslog."
fi

zip -j "$zip_file" "$output_directory"/*
rm -r "$output_directory"
echo "Logs for the current date from syslog have been zipped into $zip_file."
