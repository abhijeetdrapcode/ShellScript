#!/bin/bash

history_file=~/.bash_history
today=$(date +"%Y-%m-%d")
output_directory="/home/acer/coding/zipFolder/LinuxCommand"
output_file="$output_directory/$today-commands.txt"
zip_folder=$(date +"%Y-%m-%d")
zip_file="$output_directory/$today.zip"

mkdir -p "$output_directory"
user=$(whoami)
matched_lines=()

while IFS= read -r line; do
    timestamp="${line:1:10}" 
    if [[ "$timestamp" =~ ^[0-9]+$ ]]; then 
        date_time=$(date -d "@$timestamp" +"%Y-%m-%d %H:%M:%S")
        if [[ "${date_time:0:10}" == "$today" ]]; then  
            matched_lines+=("[$date_time] User: $user | Command: $prev_line")
        fi
    else
        prev_line="$line"
    fi
done < "$history_file"

printf "%s\n" "${matched_lines[@]}" > "$output_file"
zip -j "$zip_file" "$output_file"
rm "$output_file"

echo "Output has been stored in $zip_file"
