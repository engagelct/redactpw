#!/bin/bash

#Exit script if no args passed
[ $# -lt 2 ] && echo "Usage: $0 <string> <logdir>" && exit 1

#Disable history expansion so characters aren't misinterpreted in user input
set +H

#Take in args from user input
REDACT="$1"
LOGDIR="$2"

#Confirmation message
echo "We are redacting '$REDACT' for .log files in the directory $LOGDIR"

#Change in log directory and throw error if issue
cd "$LOGDIR" || { echo "Cannot cd into $LOGDIR"; exit 1; }

#Redact $REDACT from logs with sed
for log in *.log; do
    sed -i "s/$REDACT/REDACTED/g" "$log"
    echo "File $log has been redacted" 
done

#Ensure that redaction has happened properly
for log in *.log; do
    if grep -q "$REDACT" "$log"; then
        echo "$REDACT found in $log"
    else
        echo "$log redacted cleanly"
    fi 
done