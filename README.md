Basic bash script for redacting passwords from a folder of logs.

Syntax for running on command line is:

```
./redact.sh string_to_redact folder_to_redact_in/
```

Works on files with extension ".log", but this can be changed in the script. 

History expansion is being prevented with "set +H". The script works well in any bash. 