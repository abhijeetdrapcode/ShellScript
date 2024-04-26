#!/bin/bash

# File 1: Nginx logs
log_directory_nginx="/var/log/nginx"
zip_directory_nginx="/home/acer/coding/zipFolder/nginxLogs"

current_date_access=$(date +"%d/%b/%Y")
current_date_error=$(date +"%Y/%m/%d")

# File 2: PM2 logs
log_directory_pm2="/home/acer/.pm2/logs"
zip_directory_pm2="/home/acer/coding/zipFolder/pm2Logs"

current_date_pm2=$(date +"%Y-%m-%d")

# File 3: MongoDB logs
log_directory_mongodb="/var/log/mongodb"
zip_directory_mongodb="/home/acer/coding/zipFolder/MongoLogs"

zip_folder=$(date +"%d-%m-%Y")
current_date=$(date +"%Y-%m-%d")
main_zip_folder="/home/acer/coding/zipFolder/mainLogs"
main_zip_file="$main_zip_folder/$(date +"%d-%m-%Y")-logs.zip"

# Create directories
mkdir -p "$zip_directory_nginx" "$zip_directory_pm2" "$zip_directory_mongodb" "$main_zip_folder"

# Nginx logs
output_directory_nginx="$zip_directory_nginx/$zip_folder"
zip_file_nginx="$zip_directory_nginx/$zip_folder.zip"

# PM2 logs
output_directory_pm2="$zip_directory_pm2/$zip_folder"
zip_file_pm2="$zip_directory_pm2/$zip_folder.zip"

# MongoDB logs
output_directory_mongodb="$zip_directory_mongodb/$zip_folder"
zip_file_mongodb="$zip_directory_mongodb/$zip_folder.zip"

# Nginx logs
log_files_nginx=$(find "$log_directory_nginx" -type f)
if [ -z "$log_files_nginx" ]; then
    echo "There are no Nginx log files in the log folder."
else
    for log_file in $log_files_nginx; do
        if grep -q "$current_date_access" "$log_file"; then
            grep "$current_date_access" "$log_file" > "$output_directory_nginx/$(basename "$log_file").txt"
        elif grep -q "$current_date_error" "$log_file"; then
            grep "$current_date_error" "$log_file" > "$output_directory_nginx/$(basename "$log_file").txt"
        else
            echo "No logs found for today's date in $(basename "$log_file")"
            continue
        fi

        if [ -s "$output_directory_nginx/$(basename "$log_file").txt" ]; then
            echo "Logs containing the current date from $(basename "$log_file") have been extracted successfully."
            # Remove today's logs from the original file
            grep -v "$current_date_access" "$log_file" | grep -v "$current_date_error" > "$log_directory_nginx/$(basename "$log_file").tmp" && mv "$log_directory_nginx/$(basename "$log_file").tmp" "$log_file"
            echo "Today's logs have been removed from $(basename "$log_file")."
        else
            rm -f "$output_directory_nginx/$(basename "$log_file").txt"
        fi
    done
fi

# PM2 logs
log_files_pm2=$(find "$log_directory_pm2" -type f)
if [ -z "$log_files_pm2" ]; then
    echo "There are no PM2 log files in the log folder."
else
    for log_file in $log_files_pm2; do
        grep -E "$current_date_pm2" "$log_file" > "$output_directory_pm2/$(basename "$log_file").txt"
        if [ -s "$output_directory_pm2/$(basename "$log_file").txt" ]; then
            echo "Logs containing the current date from $(basename "$log_file") have been extracted successfully."
            # Remove today's logs from the original file
            sed -i "/$current_date_pm2/d" "$log_file"
            echo "Today's logs have been removed from $(basename "$log_file")."
        else
            rm -f "$output_directory_pm2/$(basename "$log_file").txt"
        fi
    done
fi

# MongoDB logs
log_files_mongodb=$(find "$log_directory_mongodb" -type f)
if [ -z "$log_files_mongodb" ]; then
    echo "There are no MongoDB log files in the log folder."
else
    for log_file in $log_files_mongodb; do
        if [ "$(basename "$log_file")" != "audit.json" ]; then
            grep "$current_date" "$log_file" > "$output_directory_mongodb/${current_date}-$(basename "$log_file").txt"
        else
            grep "$current_date" "$log_file" > "$output_directory_mongodb/${current_date}-$(basename "$log_file")"
        fi
        if [ -s "$output_directory_mongodb/${current_date}-$(basename "$log_file").txt" ] || [ -s "$output_directory_mongodb/${current_date}-$(basename "$log_file")" ]; then
            echo "Logs containing the current date from $(basename "$log_file") have been extracted successfully."
            # Remove today's logs from the original file
            grep -v "$current_date" "$log_file" > "$log_file.tmp" && mv "$log_file.tmp" "$log_file"
            echo "Today's logs have been removed from $(basename "$log_file")."
        else
            rm -f "$output_directory_mongodb/${current_date}-$(basename "$log_file").txt"
            rm -f "$output_directory_mongodb/${current_date}-$(basename "$log_file")"
        fi
    done
fi

# Zip individual log folders
zip -j "$zip_file_nginx" "$output_directory_nginx"/*
zip -j "$zip_file_pm2" "$output_directory_pm2"/*
zip -j "$zip_file_mongodb" "$output_directory_mongodb"/*

# Zip main folder
zip -r "$main_zip_file" "$zip_directory_nginx" "$zip_directory_pm2" "$zip_directory_mongodb"

# Clean up
rm -r "$output_directory_nginx" "$output_directory_pm2" "$output_directory_mongodb"
echo "Logs for the current date have been zipped into $zip_file_nginx, $zip_file_pm2, and $zip_file_mongodb. Main folder has been zipped into $main_zip_file."
