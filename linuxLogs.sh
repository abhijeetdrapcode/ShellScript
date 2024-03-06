#!/bin/bash

log_files=("/var/log/syslog" "/var/log/auth.log" "/var/log/kern.log")
zip_folder=$(date +"%Y-%m-%d")
output_directory="/home/acer/coding/zipFolder/OsFileZip/$zip_folder"
zip_directory="/home/acer/coding/zipFolder/OsFileZip"
zip_file="$zip_directory/$zip_folder.zip"

mkdir -p "$output_directory"

for log_file in "${log_files[@]}"; do
    current_date=$(date +"%b %e")

    if [ ! -f "$log_file" ]; then
        echo "The log file $log_file does not exist."
        continue
    fi

    grep "$current_date" "$log_file" > "$output_directory/${current_date}-$(basename $log_file).txt"

    if [ -s "$output_directory/${current_date}-$(basename $log_file).txt" ]; then
        echo "Logs containing the current date from $(basename $log_file) have been extracted successfully."
    else
        rm -f "$output_directory/${current_date}-$(basename $log_file).txt"
        echo "No logs containing the current date found in $(basename $log_file)."
    fi
done

zip -j "$zip_file" "$output_directory"/*

rm -r "$output_directory"

echo "Logs for the current date from syslog, auth.log, and kern.log have been zipped into $zip_file."
