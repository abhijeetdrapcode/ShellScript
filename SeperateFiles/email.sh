#!/bin/bash

TO="abhijeet@drapcode.com"
FROM="abhijeet4rana@gmail.com"
SUBJECT="Test Email"
BODY="This is a test email sent using mutt."

TEMP_BODY=$(mktemp)

echo "$BODY" > "$TEMP_BODY"

mutt -s "$SUBJECT" -e "my_hdr From:$FROM" "$TO" < "$TEMP_BODY"

rm "$TEMP_BODY"
