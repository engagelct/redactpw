## Redact.sh - redacts strings from log files

Basic bash script for redacting passwords from a folder of logs.

Usage: ./redact.sh [options] [string] [logdir]

Options:
  -h, --help                Show help message
  -v, --verbose             Print output to terminal


History expansion is being prevented with "set +H". The script works well in any bash. 

Extension for redaction and string to redact into can be changed in the config.conf. 