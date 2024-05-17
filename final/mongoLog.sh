#!/bin/bash

log_directory="/var/log/mongodb"
zip_directory="/home/acer/zipFolder/MongoLogs"

zip_folder=$(date +"%d-%m-%Y")
current_date=$(date +"%Y-%m-%d")

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
    if [ "$(basename "$log_file")" != "audit.json" ]; then
        grep "$current_date" "$log_file" > "$output_directory/${current_date}-$(basename "$log_file").txt"
    else
        grep "$current_date" "$log_file" > "$output_directory/${current_date}-$(basename "$log_file")"
    fi

    if [ -s "$output_directory/${current_date}-$(basename "$log_file").txt" ] || [ -s "$output_directory/${current_date}-$(basename "$log_file")" ]; then
        echo "Logs containing the current date from $(basename "$log_file") have been extracted successfully."
    else
        rm -f "$output_directory/${current_date}-$(basename "$log_file").txt"
        rm -f "$output_directory/${current_date}-$(basename "$log_file")"
        success=false
    fi
done

if zip -j "$zip_file" "$output_directory"/* && rm -r "$output_directory"; then
    if $success; then
        echo "MongoDB logs for the current date have been zipped into $zip_file."
    else
        echo "Error: Failed to extract logs from some files."
    fi
else
    echo "Error: Failed to create the zip file."
fi
