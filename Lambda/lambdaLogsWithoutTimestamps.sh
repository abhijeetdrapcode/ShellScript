#!/bin/bash

list_log_streams() {
  function_name="$1"
  aws logs describe-log-streams --log-group-name "/aws/lambda/$function_name" --query 'logStreams[*].logStreamName' 
}

fetch_log_events() {
  function_name="$1"
  log_stream_name="$2"
  aws logs get-log-events --log-group-name "/aws/lambda/$function_name" --log-stream-name "$log_stream_name" --output json
}

lambda_functions=$(aws lambda list-functions --query 'Functions[*].FunctionName')

echo "Available Lambda functions:"
echo "$lambda_functions"
echo

read -p "Enter the name of the Lambda function you want to view logs for: " function_name

if ! echo "$lambda_functions" | grep -qw "$function_name"; then
  echo "Error: The specified Lambda function does not exist."
  exit 1
fi

echo "Fetching log streams for Lambda function: $function_name"
log_streams=$(list_log_streams "$function_name")
echo "Log Streams for Lambda function $function_name:"
echo "$log_streams"
echo

read -p "Enter the name of the log stream you want to download logs from: " log_stream_name

echo "Fetching all log events for Log Stream: $log_stream_name"
log_events=$(fetch_log_events "$function_name" "$log_stream_name")

echo "Log Events for Log Stream $log_stream_name:"
echo "$log_events"
echo

read -p "Do you want to download all log events for Log Stream $log_stream_name? (yes/no): " download_choice

if [[ "$download_choice" == "yes" || "$download_choice" == "y" ]]; then
  log_stream_name_cleaned="${log_stream_name//\//_}"
  echo "$log_events" > "${function_name}-logs.json"
  echo "Log events downloaded to: ${function_name}-logs.json in the current directory."
fi