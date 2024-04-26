#!/bin/bash

log_directory="/home/acer/.pm2/logs"
zip_directory="/home/acer/zipFolder/pm2Logs"

current_date=$(date +"%Y-%m-%d")
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
    grep -E "$current_date" "$log_file" > "$output_directory/$(basename "$log_file").txt"
    if [ -s "$output_directory/$(basename "$log_file").txt" ]; then
        echo "Logs containing the current date from $(basename "$log_file") have been extracted successfully."
        # Remove today's logs from the original file
        sed -i "/$current_date/d" "$log_file"
        echo "Today's logs have been removed from $(basename "$log_file")."
    else
        rm -f "$output_directory/$(basename "$log_file").txt"
    fi
done

zip -j "$zip_file" "$output_directory"/*
rm -r "$output_directory"
echo "Logs for the current date have been zipped into $zip_file."
