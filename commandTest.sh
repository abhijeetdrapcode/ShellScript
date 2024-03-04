#!/bin/bash

history_file=~/.bash_history
today=$(date +"%Y-%m-%d")
output_directory="/home/acer/coding/zipFolder/LinuxCommand"
output_file="$output_directory/$today-commands.txt"
zip_folder=$(date +"%Y-%m-%d")
zip_file="$output_directory/$today-commands_$zip_folder.zip"

mkdir -p "$output_directory"

while IFS= read -r line; do
    timestamp=$(echo "$line" | grep -oP '^#\K\d+')

    if [[ -n "$timestamp" ]]; then
        date_time=$(date -d "@$timestamp" +"%Y-%m-%d %H:%M:%S")
        if [[ "$(date -d "@$timestamp" +%Y-%m-%d)" == "$today" ]]; then
            user=$(whoami)
            echo "[$date_time] User: $user | Command: $prev_line" >> "$output_file"
        fi
    else
        prev_line="$line"
    fi
done < "$history_file"


zip -j "$zip_file" "$output_file"


rm "$output_file"

echo "Output has been stored in $zip_file"
