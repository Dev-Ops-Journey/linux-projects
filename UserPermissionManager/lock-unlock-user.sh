#!/bin/bash

if [[ ${UID} -ne 0 ]]; then
    echo 'You do not have the permission to run this script.'
    exit 1
fi

read -p "Username: " USERNAME
read -p "Lock or Unlock (l/u)? " ACTION

case ${ACTION} in
    L|l) passwd -l ${USERNAME} ;;
    U|u) passwd -u ${USERNAME} ;;
    *) exit 1 ;;
esac

exit 0
