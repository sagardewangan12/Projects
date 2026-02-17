#!/bin/bash

# ==========================================
# Linux System Monitoring Script
# Author: Sagar Dewangan
# ==========================================

LOG_FILE="$HOME/system_monitor.log"

echo "==========================================" | tee -a $LOG_FILE
echo "System Monitoring Report - $(date)" | tee -a $LOG_FILE
echo "==========================================" | tee -a $LOG_FILE

# Hostname
echo -e "\nHostname:" | tee -a $LOG_FILE
hostname | tee -a $LOG_FILE

# Uptime
echo -e "\nSystem Uptime:" | tee -a $LOG_FILE
uptime | tee -a $LOG_FILE

# CPU Usage
echo -e "\nCPU Usage:" | tee -a $LOG_FILE
top -bn1 | grep "Cpu(s)" | tee -a $LOG_FILE

# Memory Usage
echo -e "\nMemory Usage:" | tee -a $LOG_FILE
free -h | tee -a $LOG_FILE

# Disk Usage
echo -e "\nDisk Usage:" | tee -a $LOG_FILE
df -h | tee -a $LOG_FILE

# Top 5 Memory Consuming Processes
echo -e "\nTop 5 Memory Consuming Processes:" | tee -a $LOG_FILE
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6 | tee -a $LOG_FILE

# Logged in Users
echo -e "\nLogged in Users:" | tee -a $LOG_FILE
who | tee -a $LOG_FILE

echo -e "\nReport saved to: $LOG_FILE"
echo "=========================================="
