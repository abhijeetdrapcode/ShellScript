#!/bin/bash

log_directory="/home/acer/.pm2/logs"
zip_directory="/home/acer/zipFolder/pm2Logs"

current_date=$(date +"%Y-%m-%d")

zip_folder=$(date +"%d-%m-%Y")
output_directory="$zip_directory/$zip_folder"

zip_file="$zip_directory/$zip_folder.zip"

mkdir -p "$output_directory"
log_files=$(find "$log_directory" -type f)

if [ -z "$log_files" ]; then
    echo "There are no log files in the log folder."
    exit 1
fi

success=true

for log_file in $log_files; do
    grep "$current_date" "$log_file" > "$output_directory/${current_date}-$(basename "$log_file").txt"
    if [ -s "$output_directory/${current_date}-$(basename "$log_file").txt" ]; then
        echo "Logs containing the current date from $(basename "$log_file") have been extracted successfully."
    else
        rm -f "$output_directory/${current_date}-$(basename "$log_file").txt"
        success=false
    fi
done

if zip -j "$zip_file" "$output_directory"/* && rm -r "$output_directory"; then
    if $success; then
        echo "Logs for the current date have been zipped into $zip_file."
    else
        echo "Error: Failed to extract logs from some files."
    fi
else
    echo "Error: Failed to create the zip file."
fi
