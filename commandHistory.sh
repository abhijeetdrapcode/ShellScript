#!/bin/bash

current_date=$(date +"%Y-%m-%d")
output_file="/home/acer/coding/LinuxCommands/logs-$current_date.txt"
history_file="/home/acer/coding/LinuxCommands/history_temp.txt"

username=$(whoami)

history > "$history_file"

{
    echo "User: $username"
    echo "Date: $current_date"
    echo "Commands:"
    grep "^ *[0-9]*  *$current_date" "$history_file" | awk '{$1=""; print $0}'
} > "$output_file"

rm "$history_file"

zip -j "$output_file.zip" "$output_file"

rm "$output_file"

echo "Filtered history saved to $output_file.zip"
