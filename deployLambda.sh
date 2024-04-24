#!/bin/bash

lambda_functions=$(aws lambda list-functions --query 'Functions[*].FunctionName')

echo "Available Lambda functions:"
echo "$lambda_functions"
echo

read -p "Enter the name of the Lambda function you want to deploy: " function_name

read -p "Enter the location of the Lambda function code directory in your system (e.g., /path/to/lambda/function): " code_directory

if [ ! -d "$code_directory" ]; then
    echo "Error: The specified code directory does not exist."
    exit 1
fi

code_directory=$(realpath "$code_directory")
pping
temp_dir=$(mktemp -d)

echo "Zipping Lambda function code..."
zip -j "$temp_dir/lambda_function.zip" "$code_directory"/*

echo "Deploying Lambda function: $function_name"
aws lambda update-function-code --function-name "$function_name" --zip-file "fileb://$temp_dir/lambda_function.zip"

echo "Cleaning up..."
rm -r "$temp_dir"

echo "Deployment complete."
