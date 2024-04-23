#!/bin/bash

AWS_PROFILE="default"
BUCKET_NAME="abhijeettestingbucket22"

LOG_DIR="/home/acer/coding/zipFolder/MongoLogs"

CURRENT_DATE=$(date +"%d-%m-%Y")
LOG_FILE="$LOG_DIR/$CURRENT_DATE.zip"

TO="mca22.abhijeetrana@bvicam.in"
SUBJECT="S3 Upload Notification"

if [ -f "$LOG_FILE" ]; then
    aws s3 cp "$LOG_FILE" "s3://$BUCKET_NAME/$CURRENT_DATE.zip" --profile "$AWS_PROFILE"
    if [ $? -eq 0 ]; then
        echo "Upload successful!"
        echo "Log file successfully uploaded to S3 bucket." | mail -s "$SUBJECT" "$TO"
    else
        echo "Upload failed."
        echo "Failed to upload log file to S3 bucket." | mail -s "$SUBJECT" "$TO"
    fi
else
    echo "Log file $LOG_FILE does not exist."
    echo "Log file $LOG_FILE does not exist, upload failed." | mail -s "$SUBJECT" "$TO"
fi
