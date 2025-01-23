#!/bin/bash

echo "--------------- Server Performance Stats ---------------"

# Total CPU usage
echo "Total CPU Usage:"
# Calculate total CPU usage
total_cpu=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}')
echo "CPU Usage: $total_cpu"

echo ""

# Total Memory usage
echo "Total Memory Usage:"
# Show memory usage with free vs used including percentage
mem_used=$(grep MemTotal /proc/meminfo | awk '{print $2}')
mem_free=$(grep MemFree /proc/meminfo | awk '{print $2}')
mem_buffers=$(grep Buffers /proc/meminfo | awk '{print $2}')
mem_cached=$(grep '^Cached' /proc/meminfo | awk '{print $2}')
mem_used_total=$((mem_used - mem_free + mem_buffers + mem_cached))
mem_percentage=$((mem_used_total * 100 / mem_used))
echo "Used: $((mem_used_total / 1024)) MB ($mem_percentage%)"
echo "Free: $((mem_free / 1024)) MB"

echo ""

# Total Disk usage
echo "Total Disk Usage:"
# Show disk usage for root partition
disk_used=$(df / | awk 'NR==2 {print $3}')
disk_free=$(df / | awk 'NR==2 {print $4}')
disk_total=$(df / | awk 'NR==2 {print $2}')
disk_percentage=$((disk_used * 100 / disk_total))
echo "Used: $((disk_used / 1024)) MB ($disk_percentage%)"
echo "Free: $((disk_free / 1024)) MB"

echo ""

# Top 5 processes by CPU usage
echo "Top 5 Processes by CPU Usage:"
ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -n 6

echo ""

# Top 5 processes by Memory usage
echo "Top 5 Processes by Memory Usage:"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6

echo ""

# Stretch goal: Additional stats
echo "OS Version:"
uname -a

echo ""

echo "Uptime:"
uptime

echo ""

echo "Load Average:"
cat /proc/loadavg

echo ""

echo "Logged in Users:"
who

echo ""

echo "Failed Login Attempts (last 5):"
# Note: lastb might not be available. Use 'last -n 5' if 'lastb' is unavailable.
# Uncomment the line below if available or substitute as needed.
last -n 5 | grep -i 'failed' || echo "No failed login attempts logged."

echo "----------------------------------------------------------"
