#!/bin/bash

for user_home in /home/*; do
    user=$(basename "$user_home")
    history_file="$user_home/.bash_history"
    
    if [ -f "$history_file" ]; then
        echo "User: $user"
        while read -r line; do
            timestamp=$(stat -c %Y "$history_file")
            command="$line"
            echo "Time: $(date -d @"$timestamp" '+%Y-%m-%d %H:%M:%S') User: $user Command: $command"
        done < <(grep -v '^#' "$history_file")
        echo
    fi
done
