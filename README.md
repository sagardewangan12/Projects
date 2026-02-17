
# My Linux Projects

# Linux System Monitoring Script (Bash)

## Overview

This project is a simple and practical Linux system monitoring tool built using Bash scripting. The purpose of this script is to continuously check important system metrics like CPU usage, memory consumption, disk space, system load, running services, and active processes.

Instead of manually checking system health, this script automates the monitoring process and logs useful information. It also alerts when system resources cross defined thresholds, helping detect potential issues early.

This project reflects real-world DevOps and Site Reliability Engineering (SRE) practices, where monitoring and automation are essential for maintaining reliable and stable systems.

---

## Features

This script helps monitor the overall health of a Linux system by:

- Checking CPU usage in real time  
- Monitoring memory utilization  
- Tracking disk space usage across mounted drives  
- Observing system load average  
- Verifying status of important services like SSH and Cron  
- Showing the top 5 processes consuming CPU and memory  
- Creating log files for system health tracking  
- Alerting when resource usage exceeds safe limits  
- Supporting automation through cron scheduling  

---

## Technologies Used

This project uses basic and powerful Linux tools:

- Bash scripting  
- Linux system utilities such as `top`, `ps`, `df`, `awk`, and `systemctl`  
- Cron for automating monitoring tasks  

---

## Project Structure


