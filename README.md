# SecureRecon
Commands used for OS enumeration often output lots of text to the console, making copying and pasting it by hand
tedious and error-prone.
SecureRecon is a script that automates this task by running CMD commands used for Windows
enumeration and saving each command's output locally in a seperate file for further processing.

## Prerequisites
1. SSH login credentials for the target machine.
2. [SSHPpass](https://linux.die.net/man/1/sshpass): install on Debian-based distros with "sudo apt install sshpass".

## Installation
```bash
git clone
chmod +x sr-cmd.sh
nano commands.bat # place CMD commands in this file
```

## Usage
The `commands.cmd` file includes example CMD commands to be run by the script.
Run `./sr-cmd.sh -h` to display the script's help message:
```
Usage: sr-cmd.sh -u [username] -p [password] -i [ip] -P [optional port]

Important: The script expects a "commands.cmd" file in its working directory

Examples:
sr-cmd.sh -u auser -p s3cret -i 1.1.1.1
sr-cmd.sh --username auser --password s3cret -i 1.1.1.1 -P 2222

Flags:
    -u, --username  SSH username
    -i, --ip        IPv4 address
    -p, --password  SSH password
    -P, --port      SSH port, defaults to 22 if none given
    -h, --help      Print this help message and exit
``` 

## ToDo
- [ ] Write versions for other interpreters - Bash, PowerShell, etc.
