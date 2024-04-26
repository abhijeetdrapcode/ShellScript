#!/bin/bash

# Check Disk Space
DISK_SPACE=$(df -h / | awk 'NR==2 {print $5}')

# Threshold (80%)
THRESHOLD="18%"

# Check if Disk Space exceeds threshold
if [ "${DISK_SPACE%?}" -gt "${THRESHOLD%?}" ]; then
    MESSAGE="Disk space usage is at $DISK_SPACE. It has exceeded the threshold of $THRESHOLD. Please check and free up some space."
    echo "$MESSAGE"
else
    echo "Disk space usage is at $DISK_SPACE. Everything is within the threshold."
fi
