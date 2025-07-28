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

#Setting up flags
while test $# -gt 0; do
  case "$1" in

    -h|--help)
      echo "Redact.sh - redacts strings from log files"
      echo
      echo "Usage: ./redact.sh [options] <string> <logdir>"
      echo
      echo "Options:"
      echo "  -h, --help                Show help message"
      echo "  -v, --verbose             Print output to terminal"
      exit 0
      ;;
    
    #Set verbose for output to terminal
    -v|--verbose)
      VERBOSE=true
      ;;

    #No arguments provided or 
    *)
      break
      ;;

  esac
  shift
done

#Exit script if no args passed
[ $# -lt 2 ] && echo "Usage: $0 <string> <logdir>" && exit 1


#Testing - comment these out if not using
#rm -rf test_logs_clone/
#cp -r test_logs/ test_logs_clone/


#Take in args from user input
REDACT="$1"
LOGDIR="$2"


#Confirmation message
[ "$VERBOSE" = true ] && echo "We are redacting '$REDACT' for $FILE_EXTENSION files in the directory $LOGDIR"


#Change in log directory and throw error if issue
cd "$LOGDIR" || { echo "Cannot cd into $LOGDIR"; exit 1; }


#Ensure that some $FILE_EXTENSION files exist in specified directory
shopt -s nullglob
logs=(*$FILE_EXTENSION)
[ ${#logs[@]} -eq 0 ] && echo "No $FILE_EXTENSION files found." && exit 1


#Redact $REDACT from logs with sed
for log in *$FILE_EXTENSION; do

    #If string to redact exists in file
    if grep -q "$REDACT" "$log"; then

        #Replace all literal occurrences of the $REDACT string with "REDACTED"
        sed -i "s|$(printf '%s\n' "$REDACT" | sed 's/[\/&]/\\&/g')|"$REDACTED"|g" "$log"
        [ "$VERBOSE" = true ] && echo "File $log has been redacted"
    
    #If string to redact non-existent
    else
        [ "$VERBOSE" = true ] && echo "File $log does not contain requested string: $REDACT."
    fi 
done


#Ensure that redaction has happened properly
for log in *$FILE_EXTENSION; do
    if grep -q "$REDACT" "$log"; then
        [ "$VERBOSE" = true ] && echo "$REDACT found in $log"
    else
        [ "$VERBOSE" = true ] && echo "$log processed cleanly"
    fi 
done