
#!/bin/bash

# Function to add 5 hours and 30 minutes to the current time
add_time() {
  local current_time=$(date +%s)
  local adjusted_time=$((current_time + 5*3600 + 30*60))
  date -d "@$adjusted_time" "+%Y-%m-%d %H:%M:%S"
}

list_log_streams() {
  function_name="$1"
  aws logs describe-log-streams --log-group-name "/aws/lambda/$function_name" --query 'logStreams[*].logStreamName' 
}

fetch_log_events() {
  function_name="$1"
  log_stream_name="$2"
  aws logs get-log-events --log-group-name "/aws/lambda/$function_name" --log-stream-name "$log_stream_name" --output json
}

convert_timestamp() {
  local milliseconds="$1"
  local adjusted_time=$(($milliseconds + 5*3600*1000 + 30*60*1000))  
  TZ="Asia/Kolkata" date -d "@$((adjusted_time / 1000))" "+%Y-%m-%d %H:%M:%S %Z"
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

log_events_converted=$(echo "$log_events" | jq '.events[] | .timestamp |= . / 1000 | .timestamp |= strftime("%Y-%m-%d %H:%M:%S %Z")')

echo "Log Events for Log Stream $log_stream_name:"
echo "$log_events_converted"
echo

read -p "Do you want to download all log events for Log Stream $log_stream_name? (yes/no): " download_choice

if [[ "$download_choice" == "yes" || "$download_choice" == "y" ]]; then
  log_stream_name_cleaned="${log_stream_name//\//_}"
  echo "$log_events_converted" > "${function_name}-${log_stream_name_cleaned}-logs.json"
  echo "Log events downloaded to: ${function_name}-${log_stream_name_cleaned}-logs.json in the current directory."
fi
