#!/bin/bash
set -euo pipefail

LOG="/var/log/check_service.log"
SERVICE="httpd"
PKG="httpd"

# timestamp helper
ts() { date '+%F %T'; }

echo "$(ts) – Starting $SERVICE health check…" | tee -a "$LOG"

# Install if missing
if ! rpm -q "$PKG" &>/dev/null; then
  echo "$(ts) – $PKG not installed. Installing…" | tee -a "$LOG"
  yum update -y               | tee -a "$LOG"
  yum install -y "$PKG"       | tee -a "$LOG"
  systemctl enable "$SERVICE" | tee -a "$LOG"
fi

# Check status & restart if needed
if systemctl is-active --quiet "$SERVICE"; then
  echo "$(ts) – $SERVICE is running." | tee -a "$LOG"
else
  echo "$(ts) – $SERVICE is NOT running. Restarting…" | tee -a "$LOG"
  systemctl restart "$SERVICE"
  if systemctl is-active --quiet "$SERVICE"; then
    echo "$(ts) – $SERVICE restarted successfully." | tee -a "$LOG"
  else
    echo "$(ts) – ERROR: Failed to restart $SERVICE!" | tee -a "$LOG"
    exit 1
  fi
fi

echo "$(ts) – Health check complete." | tee -a "$LOG"
