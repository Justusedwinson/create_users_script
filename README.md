Creating User and Group Management with Bash Script Automation.

Task:
Your company has employed many new developers. As a SysOps engineer, write a bash script called create_users.sh that reads a text file containing the employee’s usernames and group names, where each line is formatted as user;groups.
The script should create users and groups as specified, set up home directories with appropriate permissions and ownership, generate random passwords for the users, and log all actions to /var/log/user_management.log. Additionally, store the generated passwords securely in /var/secure/user_passwords.txt.
Ensure error handling for scenarios like existing users and provide clear documentation and comments within the script.

Solution:
To automate user and group management, the script reads a text file containing usernames and group names, processes each line, and splits it into username and groups while removing any whitespace. It ensures each user has a personal group, creates additional groups if needed, and assigns users to these groups. Home directories are set up with appropriate permissions, and random passwords are generated and securely stored. All actions, including user creation and group assignments, are logged. The script also includes error handling for existing users or groups.

Create folders for logs and secure passwords
    *mkdir -p /var/log /var/secure*
Create files for logs and password storage
    *touch /var/log/user_management.log*
    *touch /var/secure/user_passwords.txt*
Make the password file secure
    *chmod 600 /var/secure/user_passwords.txt*
Define a function that logs action
    log_action() {
    echo "$(date) - $1" >> "/var/log/user_management.log"
    }
Create a function that handles user creation. This function does the following:

This checks if the user already exists by calling the id command and redirecting the output to /dev/null. If the user exists, it logs a message and returns.
Creates a personal group for the user using the groupadd command.
Creates the additional groups if they do not exist.
Creates the user with the useradd command, setting the home directory, shell, and primary group.
Logs a message indicating the success or failure of the useradd command.
Adds the user to the other groups using the usermod command.
Generates a random password for the user using /dev/urandom and stores the user and their respective password in /var/secure/user_passwords.txt, the secure password file.
Sets the permissions and ownership.