#!/bin/bash

if [[ ${UID} -ne 0 ]]; then
    echo 'You do not have the permission to execute this script.'
    exit 1
fi

reportFailure() {
    local message=$1
    echo "${message}"
    exit 1
}

checkOption() {
    local option=$1
    case ${option} in
        y|Y) return 0 ;;
        n|N) exit 0 ;;
        *) echo 'Invalid option. Terminating...'; exit 1 ;;
    esac
}

# Creating a user
read -p "Username: " USERNAME
sudo useradd -m ${USERNAME}
if [[ $? -ne 0 ]]; then
    reportFailure 'Failed to create user'
fi

# Assigning password
read -s -p "Password: " PASSWORD
echo ""
echo -e "${PASSWORD}\n${PASSWORD}" | sudo passwd ${USERNAME}
if [[ $? -ne 0 ]]; then
    reportFailure 'Failed to create user'
else
    echo 'User created successfully!'
fi

# Creating a group
read -p "Create a new group? (Y/N) " OPTION
checkOption ${OPTION}

read -p "New Group: " GROUP
sudo groupadd ${GROUP}
if [[ $? -ne 0 ]]; then
    reportFailure "Failed to create group: ${GROUP}"
fi

sudo usermod -aG ${GROUP} ${USERNAME}
if [[ $? -ne 0 ]]; then
    reportFailure "Created group: ${GROUP}, but failed to assign ${USERNAME} into the group"
else
    echo "Group ${GROUP} added and user ${USERNAME} assigned into it"
fi

# Creating a new dummy directory
read -p "Create a new directory for user ${USERNAME}? (Y/N) " OPTION
checkOption ${OPTION}
USER_BASE_DIR=$(sudo getent passwd ${USERNAME} | cut -d : -f6)
if [[ $? -ne 0 ]]; then
    reportFailure 'Failed to get user path directory'
fi

read -p "Directory name: " NEW_DIR
FULLPATH="${USER_BASE_DIR}/${NEW_DIR}"
mkdir -p "${FULLPATH}"
chown ${USERNAME}:${GROUP} "${FULLPATH}"
chmod 755 "${FULLPATH}"
