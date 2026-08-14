#!/usr/bin/env bash

# Stop if an undefined variable is used. This keeps mistakes easier to find.
set -u

# Thresholds can be changed based on your lab needs.
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

# Store logs in the project logs directory by default.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
LOG_DIR="${PROJECT_DIR}/logs"
LOG_FILE="${LOG_DIR}/health_check.log"

mkdir -p "${LOG_DIR}"

# Print to terminal and save the same message to the log file.
log_message() {
  local message="$1"
  echo "${message}" | tee -a "${LOG_FILE}"
}

# CPU usage is calculated from the idle percentage reported by top.
check_cpu_usage() {
  local cpu_idle
  local cpu_usage

  cpu_idle=$(top -bn1 | awk -F'id,' '/Cpu\(s\)/ { split($1, values, ","); print values[length(values)] }' | awk '{print $NF}')
  cpu_usage=$(awk -v idle="${cpu_idle}" 'BEGIN { printf "%.0f", 100 - idle }')

  log_message "CPU Usage: ${cpu_usage}%"

  if (( cpu_usage > CPU_THRESHOLD )); then
    log_message "WARNING: CPU usage is above ${CPU_THRESHOLD}%"
  fi
}

# Memory usage is calculated using the 'free' command.
check_memory_usage() {
  local memory_usage

  memory_usage=$(free | awk '/Mem:/ { printf "%.0f", ($3 / $2) * 100 }')

  log_message "Memory Usage: ${memory_usage}%"

  if (( memory_usage > MEMORY_THRESHOLD )); then
    log_message "WARNING: Memory usage is above ${MEMORY_THRESHOLD}%"
  fi
}

# Disk usage checks the root filesystem by default.
check_disk_usage() {
  local disk_usage

  disk_usage=$(df / | awk 'NR==2 { gsub("%", "", $5); print $5 }')

  log_message "Disk Usage on /: ${disk_usage}%"

  if (( disk_usage > DISK_THRESHOLD )); then
    log_message "WARNING: Disk usage is above ${DISK_THRESHOLD}%"
  fi
}

log_message "----------------------------------------"
log_message "Health Check Time: $(date)"
log_message "Hostname: $(hostname)"

check_cpu_usage
check_memory_usage
check_disk_usage

log_message "Health check completed. Log saved to ${LOG_FILE}"
