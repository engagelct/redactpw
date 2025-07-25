#!/bin/bash

#Exit script if no args passed
[ $# -lt 2 ] && echo "Usage: $0 <string> <logdir>" && exit 1

#Disable history expansion so characters aren't misinterpreted in user input
set +H

#Cleanup - for testing
#rm -rf test_logs_clone/
#cp -r test_logs/ test_logs_clone/

#Take in args from user input
REDACT="$1"
LOGDIR="$2"

echo $REDACT
echo $LOGDIR

cd "$LOGDIR" || { echo "Cannot cd into $LOGDIR"; exit 1; }
pwd

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