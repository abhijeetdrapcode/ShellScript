#!/bin/bash


#change these variables according to the directory where log files are being created and where u want to store them and don't give spaces after the equal to sign as it will consider it as a linux commnad
log_directory="/home/acer/.pm2/logs"
output_directory="/home/acer/coding/LogFileZip"



mkdir -p "$output_directory"

read -p "Enter the date you want to find the logs for (YYYY-MM-DD): " date

log_files=$(find "$log_directory" -type f)

if [ -z "$log_files" ]; then
    echo "There are no log files in the log folder."
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
