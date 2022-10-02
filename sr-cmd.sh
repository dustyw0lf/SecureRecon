#!/bin/bash
# SecureRecon - CMD:
# Run CMD commands for Windows enumeration via SSH and save 
# each command's output in a seperate file for further processing

# Prerequisites:
# 1. SSH login credentials
# 2. sshpass

HELP=$(cat <<-END
Usage: sr-cmd.sh -u [username] -p [password] -i [ip] -P [optional port]

Important: The script expects a "commands.bat" file in its working directory

Examples:
sr-cmd.sh -u auser -p s3cret -i 1.1.1.1
sr-cmd.sh --username auser --password s3cret -i 1.1.1.1 -P 2222

Flags:
    -u, --username  SSH username
    -i, --ip        IPv4 address
    -p, --password  SSH password
    -P, --port      SSH port, defaults to 22 if none given
    -h, --help      Print this help message and exit
END
)

# ----Get command line arguments----
while [[ $# -gt 0 ]]; do
  case $1 in
    -u|--username)
      USERNAME="$2"
      shift # past argument
      shift # past value
      ;;
    -i|--ip)
      IP="$2"
      shift
      shift
      ;;
    -p|--password)
      PASSWORD="$2"
      shift
      shift
      ;;
    -P|--port)
      PORT="$2"
      shift
      shift
      ;;
    -h|--help)
      echo "$HELP"
      exit 1
      ;;
    -*|--*)
      echo "Unknown option $1"
      echo "$HELP"
      exit 1
      ;;
  esac
done

# ---Check if sshpass is installed--
sshpass -v >/dev/null 2>&1 || { echo '[!] ERROR: cannot find sshpass. make sure it is installed and in your PATH'; exit 1; }

# ---Check command line arguments---
CHECK_USERNAME=true
CHECK_IP=true
CHECK_PASSWORD=true

[[ -z "$USERNAME" ]] && CHECK_USERNAME=false && echo '[!] ERROR: provide a username'
[[ -z "$IP" ]] && CHECK_IP=false && echo '[!] ERROR: provide an IPv4 address'
[[ -z "$PASSWORD" ]] && CHECK_PASSWORD=false && echo '[!] ERROR: provide a password'

if [ "$CHECK_USERNAME" = false ] || [ "$CHECK_IP" = false ] || [ "$CHECK_PASSWORD" = false ]; then
     exit 1
fi

# Default to port 22 if no port number was given
[[ -z "$PORT" ]] && PORT="22"

# --Run commands and split their output into different files--
sshpass -p "$PASSWORD" ssh -p "$PORT" "$USERNAME"@"$IP" 'cmd' < commands.bat | csplit -sz - '/^[a-zA-Z]:\\.*\>/' '{*}'
# remove unneeded file
[[ -e xx00 ]] && rm xx00

files=$(find . -type f -name 'x*' | tr -d './')

for file in $files; do
    # Get file name from each file's first line so it could be renamed later
    file_name="$(sed 1q "$file" | sed 's/\//-/g' | awk -F '>' '{print $2}' | awk 'BEGIN{FS=" "; OFS="_"} {print $1,$2,$3}').txt"
    # If file name ends with _.txt, remove the underscore
    [[ "$file_name" =~ _\.txt$ ]] && file_name=$(echo -n "$file_name" | tr -d '_')
    # catch an unneeded file, remove it and continue
    [[ "$file_name" == .txt ]] && rm "$file" && continue
    # Rename file from x* to a descriptive name
    mv "$file" "$file_name" && echo "[*] created file: $file_name" || echo "[!] ERROR: failed to rename $file"
done
