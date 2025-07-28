Basic bash script for redacting passwords from a folder of logs.

Syntax for running on command line is:

```
./redact.sh [options] <string> <logdir>
```

Extension for redaction and string to redact into can be changed in the config.conf. 

History expansion is being prevented with "set +H". The script works well in any bash. 