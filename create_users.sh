#!/bin/bash

# Script to create users and groups and set up their home directories
# Log actions to /var/log/user_management.log
# Store generated passwords securely in /var/secure/user_passwords.txt

LOG_FILE="/var/log/user_management.log"
PASSWORD_FILE="/var/secure/user_passwords.txt"
INPUT_FILE="$1"

# Check input file provided
if [ -z "$INPUT_FILE" ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

# Check if input file provided exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Input file not found!"
    exit 1
fi

# /var/secure directory exists
mkdir -p /var/secure
chmod 700 /var/secure

# Clear log file and password file
> "$LOG_FILE"
> "$PASSWORD_FILE"

# Function to log messages
log_message() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" >> "$LOG_FILE"
}

# Function to generate a random password
generate_password() {
    tr -dc A-Za-z0-9 </dev/urandom | head -c 12
}

# Read input file line by line
while IFS=';' read -r username groups; do
    if id -u "$username" >/dev/null 2>&1; then
        log_message "User $username already exists."
        continue
    fi

    # Create groups if they don't exist
    IFS=',' read -r -a group_array <<< "$groups"
    for group in "${group_array[@]}"; do
        if ! getent group "$group" >/dev/null 2>&1; then
            groupadd "$group"
            log_message "Group $group created."
        else
            log_message "Group $group already exists."
        fi
    done

    # Create user with groups
    useradd -m -G "$groups" "$username"
    log_message "User $username created with groups $groups."

    # Permissions for home directory
    chmod 700 "/home/$username"
    chown "$username:$username" "/home/$username"
    log_message "Home directory for $username set up with proper permissions."

    # Generate and set password
    password=$(generate_password)
    echo "$username:$password" | chpasswd
    log_message "Password set for user $username."

    # Store password securely
    echo "$username:$password" >> "$PASSWORD_FILE"

done < "$INPUT_FILE"

# Secure the password file
chmod 600 "$PASSWORD_FILE"
log_message "Password file secured."

echo "User creation process completed. Check $LOG_FILE for details."