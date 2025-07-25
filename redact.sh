#!/bin/bash

#Script for redacting passwords from a folder full of logs

#Cleanup
rm -rf test_logs_clone/
cp -r test_logs/ test_logs_clone/

#Change to log directory
cd test_logs_clone

#Create list of all logs in directory for looping
LOGSLIST=$(ls * | grep '\.log$')
echo $LOGSLIST

#Define string being redacted
echo "Enter the string you wish to redact:"
read REDACT
echo "You are redacting $REDACT"

#Redact $REDACT from logs with sed
for log in *.log; do
    sed -i "s/$REDACT/REDACTED/g" "$log"
    echo "File $log has been redacted" 
done

#Ensure that redaction has happened properly
for log in $LOGSLIST; do
    if grep -q $REDACT $log; then
        echo "$REDACT found in $log"
    else
        echo "$log redacted cleanly"
    fi 
done