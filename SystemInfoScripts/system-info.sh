#!/bin/bash

SEPARATOR="$(printf '%.0s-' {1..100})"

# Display OS version, uname -r to display the kernel release version
echo "OS Version: $( cat /etc/os-release | grep PRETTY_NAME | cut -d = -f2 | tr -d '"')"
echo "Kernel: $( uname -r )"
echo "$SEPARATOR"

# Display disk usage in human readable format, sort by descending available
echo "Disk Usage:"
df -h | sort -k4 --reverse
echo "$SEPARATOR"

# Display CPU usage, run top with -b, batch mode and -n 1 for 1 iterations
echo "CPU Model: $( cat /proc/cpuinfo | grep "model name" | head -1 | cut -d : -f2 | xargs)"
echo "CPU Usage:"
top -b -n 1
echo "$SEPARATOR"

# Display the RAM usage with human readable format
echo "Memory Usage:"
free -h
echo "$SEPARATOR"

# Display uptime in pretty format
echo "System uptime: $( uptime -p )"
echo "$SEPARATOR"

# Display all current logged in users
echo "Logged in users:"
who -u
