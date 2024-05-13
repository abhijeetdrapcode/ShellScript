#!/bin/bash

history_file=~/.bash_history
output_directory="/home/acer/zipFolder/LinuxCommand"
today=$(date +"%Y-%m-%d")
zip_folder=$(date +"%d-%m-%Y")
output_file="$output_directory/$zip_folder-commands.txt"
zip_file="$output_directory/$zip_folder.zip"

mkdir -p "$output_directory"
user=$(whoami)
ip_address=$(hostname -I | awk '{print $1}')
matched_lines=()

while IFS= read -r line; do
    timestamp="${line:1:10}"
    if [[ "$timestamp" =~ ^[0-9]+$ ]]; then
        date_time=$(date -d "@$timestamp" +"%Y-%m-%d %H:%M:%S")
        if [[ "${date_time:0:10}" == "$today" ]]; then
            matched_lines+=("[$date_time] User: $user | IP: $ip_address |Command: $prev_line")
        fi
    else
        prev_line="$line"
    fi
done < "$history_file"

printf "%s\\n" "${matched_lines[@]}" > "$output_file"

if zip -j "$zip_file" "$output_file" && rm "$output_file"; then
    echo "Output has been stored in $zip_file"
else
    echo "Error: Failed to create the zip file."
fi