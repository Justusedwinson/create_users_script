Creating User Automation Bash Script

Automating the creation and configuration of user accounts helps streamline operations and ensure consistency across teams. This repository contains a Bash script for automating the creation of users and groups, setting up home directories, and generating random passwords. All actions are logged, and passwords are stored securely.

1. Create a new file for the script on your EC2 instance:
    touch create_users.sh

2. Edit the file using a text editor like nano or v:
    nano create_users.sh

3. copy and save the file and exit the editor

4. Make the script executable by running:
    chmod +x create_users.sh

5. Create the input file containing the user and group information:
    nano user_input.txt

6. Add the user and group information to the file. Each line should be in the format user; groups:
    justus;developers,admins
    michael;developers
    rawlings;admins

7. Save the file and exit the editor

8. Ensure the necessary directories and files exist and have appropriate permissions:
    sudo mkdir -p /var/secure
    sudo chmod 700 /var/secure
    sudo touch /var/log/user_management.log
    sudo touch /var/secure/user_passwords.txt

9. Run the script with the input file as an argument:
    sudo ./create_users.sh user_input.txt

10. Check the log file to see the actions taken by the script:
    cat /var/log/user_management.log

11. Verify the passwords have been securely stored:
    sudo cat /var/secure/user_passwords.txt

12. Ensure the passwd package is installed if needed (it should be pre-installed on most Ubuntu systems):
    sudo apt-get update
    sudo apt-get install passwd


Key Explanation: 

Logging Function: The log function writes messages to /var/log/user_management.log with a timestamp.

User and Group Creation: The script reads each line from the input file, creates a user and assigns them to their respective groups.

Password Management: A random password is generated for each user and stored securely in /var/secure/user_passwords.txt.