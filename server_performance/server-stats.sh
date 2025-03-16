#!/bin/bash

echo "===== Server Performance Statistics ====="
echo "-----------------------------------------"

# CPU Usage
cpu_idle=$(top -bn1 | grep "%Cpu(s)" | grep -o '[0-9.]\+ id' | awk '{print $1}')
cpu_usage=$(echo "100 - $cpu_idle" | bc)
printf "\nCPU Usage: %s%%\n" "$cpu_usage"

# Memory Usage
read -r mem_total mem_used mem_free <<< $(free -m | awk '/Mem:/ {print $2, $3, $4}')
mem_percent=$(echo "scale=2; $mem_used / $mem_total * 100" | bc)
printf "\nMemory Usage:\n"
printf "Total: %sMB  Used: %sMB (%s%%)  Free: %sMB\n" "$mem_total" "$mem_used" "$mem_percent" "$mem_free"

# Disk Usage
read -r disk_total disk_used disk_free disk_percent <<< $(df -h / | awk 'NR==2 {print $2, $3, $4, $5}')
printf "\nDisk Usage:\n"
printf "Total: %s  Used: %s (%s)  Free: %s\n" "$disk_total" "$disk_used" "$disk_percent" "$disk_free"

# Process Statistics
printf "\nTop 5 Processes by CPU Usage:\n"
ps aux --sort=-%cpu | awk 'NR<=6 {print $0}'

printf "\nTop 5 Processes by Memory Usage:\n"
ps aux --sort=-%mem | awk 'NR<=6 {print $0}'

# Stretch Goals
# OS Version
os_info=$(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)
printf "\nOS Version: %s\n" "$os_info"

# Uptime and Load Average
uptime_info=$(uptime -p)
load_avg=$(uptime | awk -F'load average: ' '{print $2}')
printf "\nUptime: %s\n" "$uptime_info"
printf "Load Average: %s\n" "$load_avg"

# Logged-in Users
logged_users=$(who | awk '{printf "%s ", $1}' | tr ' ' '\n' | sort -u | tr '\n' ' ')
printf "\nLogged-in Users: %s\n" "$logged_users"

