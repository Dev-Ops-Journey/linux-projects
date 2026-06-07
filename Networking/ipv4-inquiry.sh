#!/bin/bash

echo -e 'Interface\tStatus\tIPv4Address'
echo '==================================='
# 'inet ' -> search for ipv4
# cut -d / -f1 only display status and IPv4 addresses, without the subnet length
ip addr | awk '
/^[0-9]+:/ {
    split($2, a, ":");
    interface = a[1];
    status=(/UP/ ? "UP" : "DOWN")
}
/inet / && /scope global/ {
    print interface "\t\t" status "\t" $2  
}' | cut -d / -f1

