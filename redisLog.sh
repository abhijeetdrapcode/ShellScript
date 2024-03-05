#!/bin/bash

log_file="/var/log/redis/redis-server.log"
current_date=$(date +"%d %b %Y") 
zip_folder=$(date +"%d-%m-%Y")
output_directory="/home/acer/coding/zipFolder/RedisLogFileZip/$zip_folder"
zip_directory="/home/acer/coding/zipFolder/RedisLogFileZip"
zip_file="$zip_directory/logs-$zip_folder.zip"
rediscli_history="/home/acer/.rediscli_history"

mkdir -p "$output_directory"

if [ ! -f "$log_file" ]; then
    echo "The log file $log_file does not exist."
    exit 1
fi

tail -n 500 "$rediscli_history" > "$output_directory/rediscli_history_last_500_lines.txt"
grep "$current_date" "$log_file" > "$output_directory/${current_date}-redis-logs.txt"

if [ -s "$output_directory/${current_date}-redis-logs.txt" ]; then
    echo "Logs containing the current date from redis-server have been extracted successfully."
else
    rm -f "$output_directory/${current_date}-redis-server-logs.txt"
    echo "No logs containing the current date found in redis-server."
fi

zip -j "$zip_file" "$output_directory"/*
rm -r "$output_directory"
echo "Logs for the current date from redis-server and last 500 lines of .rediscli_history have been zipped into $zip_file."
