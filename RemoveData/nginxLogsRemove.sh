#!/bin/bash

log_directory="/var/log/nginx"
zip_directory="/home/acer/zipFolder/nginxLogs"

current_date_access=$(date +"%d/%b/%Y")
current_date_error=$(date +"%Y/%m/%d")

zip_folder=$(date +"%d-%m-%Y_%H-%M-%S")
output_directory="$zip_directory/$zip_folder"
zip_file="$zip_directory/$zip_folder.zip"

mkdir -p "$output_directory"
log_files=$(find "$log_directory" -type f)

if [ -z "$log_files" ]; then
    echo "There are no log files in the log folder."
    exit 1
fi

for log_file in $log_files; do
    if grep -q "$current_date_access" "$log_file"; then
        grep "$current_date_access" "$log_file" > "$output_directory/$(basename "$log_file").txt"
    elif grep -q "$current_date_error" "$log_file"; then
        grep "$current_date_error" "$log_file" > "$output_directory/$(basename "$log_file").txt"
    else
        echo "No logs found for today's date in $(basename "$log_file")"
        continue
    fi

    if [ -s "$output_directory/$(basename "$log_file").txt" ]; then
        echo "Logs containing the current date from $(basename "$log_file") have been extracted successfully."
        grep -v "$current_date_access" "$log_file" | grep -v "$current_date_error" > "$log_directory/$(basename "$log_file").tmp" && mv "$log_directory/$(basename "$log_file").tmp" "$log_file"
        echo "Today's logs have been removed from $(basename "$log_file")."
    else
        rm -f "$output_directory/$(basename "$log_file").txt"
    fi
done

zip -j "$zip_file" "$output_directory"/*
rm -r "$output_directory"
echo "Logs for the current date have been zipped into $zip_file."
