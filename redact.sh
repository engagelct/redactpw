#!/bin/bash

#Disable history expansion so characters aren't misinterpreted in user input
set +H


#Setting up user configurations
CONFIG_FILE="config.conf"

if [ -f "$CONFIG_FILE" ]; then
  source "$CONFIG_FILE"
else
  echo "Config not found: $CONFIG_FILE" >&2
  exit 1
fi


#Exit script if no args passed
[ $# -lt 2 ] && echo "Usage: $0 <string> <logdir>" && exit 1


#Testing
rm -rf test_logs_clone/
cp -r test_logs/ test_logs_clone/


#Take in args from user input
REDACT="$1"
LOGDIR="$2"


#Confirmation message
echo "We are redacting '$REDACT' for .log files in the directory $LOGDIR"


#Change in log directory and throw error if issue
cd "$LOGDIR" || { echo "Cannot cd into $LOGDIR"; exit 1; }


#Ensure that some .log files exist in specified directory
shopt -s nullglob
logs=(*.log)
[ ${#logs[@]} -eq 0 ] && echo "No .log files found." && exit 1


#Redact $REDACT from logs with sed
for log in *.log; do

    #If string to redact exists in file
    if grep -q "$REDACT" "$log"; then

        #Replace all literal occurrences of the $REDACT string with "REDACTED"
        sed -i "s|$(printf '%s\n' "$REDACT" | sed 's/[\/&]/\\&/g')|REDACTED|g" "$log"
        echo "File $log has been redacted"
    
    #If string to redact non-existent
    else
        echo "File $log does not contain requested string: $REDACT."
    fi 
done


#Ensure that redaction has happened properly
for log in *.log; do
    if grep -q "$REDACT" "$log"; then
        echo "$REDACT found in $log"
    else
        echo "$log processed cleanly"
    fi 
done