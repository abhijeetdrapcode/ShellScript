#!/bin/bash

log_files=("/var/log/syslog" "/var/log/auth.log" "/var/log/kern.log")
zip_directory="/home/acer/zipFolder/LinuxLogs"

zip_folder=$(date +"%d-%m-%Y")

output_directory="$zip_directory/$zip_folder"
zip_file="$zip_directory/$zip_folder.zip"

mkdir -p "$output_directory"

success=true

for log_file in "${log_files[@]}"; do
    current_date=$(date +"%b %e")
    if [ ! -f "$log_file" ]; then
        echo "The log file $log_file does not exist."
        continue
    fi

    grep "$current_date" "$log_file" > "$output_directory/${current_date}-$(basename "$log_file").txt"
    if [ -s "$output_directory/${current_date}-$(basename "$log_file").txt" ]; then
        echo "Logs for the current date for $(basename "$log_file") have been extracted successfully."
    else
        rm -f "$output_directory/${current_date}-$(basename "$log_file").txt"
        success=false
        echo "No logs containing the current date found in $(basename "$log_file")."
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
