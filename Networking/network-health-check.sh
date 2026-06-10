# Running this script on my local WSL
# by supplying the script parameter IP as my VM machine IP address


#!/bin/bash

echo "==============================="
echo " Network Health Check: $IP"
echo " $(date)"
echo "==============================="

IP=$1

# Test reachability by pinging the IP
if ping -c 5 -W 2 $IP &>/dev/null; then
    echo "$IP reachable"
else
    echo "$IP unreachable"
    exit 1
fi

# Inspect the open ports
echo ""
echo "=== Open Ports ($IP)==="
nmap -sV --open $IP

# Inspect traffic with traceroute
# set caps at 15 hops with -m 15
# set a waiting time for 2 seconds with -w 2
echo ""
echo "=== Route to $IP ==="
traceroute -m 15 -w 2 $IP

# Inspect ssh connectivity
echo ""
echo "=== SSH Connectivity ($IP) ==="
if ssh -o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=no "$IP" exit 2>/dev/null; then
    echo "SSH connection to $IP successful (key-based auth)"
else
    echo "SSH connection to $IP failed (no key, refused, or timeout)"
fi

# Inpsect active connection with ss
echo ""
echo "=== Active Connections to $IP ==="
CONNS=$(ss -tn dst "$IP")
if [[ $(echo "$CONNS" | wc -l) -le 1 ]]; then
    echo "No active connections to $IP"
else
    echo "$CONNS"
fi
