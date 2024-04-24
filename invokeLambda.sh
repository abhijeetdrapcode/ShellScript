#!/bin/bash

lambda_functions=$(aws lambda list-functions --query 'Functions[*].FunctionName')

echo "Available Lambda functions:"
echo "$lambda_functions"
echo

read -p "Enter the name of the Lambda function you want to invoke: " function_name

read -p "Enter the payload (input data) for the Lambda function (optional): " payload

if [ -z "$payload" ]; then
    aws lambda invoke --function-name "$function_name" /dev/stdout
else
    aws lambda invoke --function-name "$function_name" --payload "$payload" /dev/stdout
fi
