#!/bin/bash

download_folder="$HOME/Downloads"

lambda_functions=$(aws lambda list-functions --query 'Functions[*].FunctionName' --output text)

echo "Available Lambda functions:"
echo "$lambda_functions"
echo

read -p "Enter the name of the Lambda function you want to download: " function_name

echo "Downloading Lambda function: $function_name"
download_location=$(aws lambda get-function --function-name "$function_name" --query 'Code.Location' --output text)

mkdir -p "$download_folder"

curl -o "$download_folder/$function_name.zip" "$download_location"

echo "Lambda function downloaded to: $download_folder/$function_name.zip"
