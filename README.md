Basic bash script for redacting passwords from a folder of logs.

Syntax for running on command line is:

```
./redact.sh string_to_redact folder_to_redact_in/

```

History expansion is being prevented with set +H, but this is unnecessary with WSL. 