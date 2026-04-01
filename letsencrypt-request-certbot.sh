#!/bin/bash

# --- Safety First ---
# -e: exit on error, -u: error on undefined vars
set -eu

# --- Configuration ---
# Use $HOME to make the script portable for any non-root user
BASE_DIR="$HOME/certbot"
DOMAIN="*.mydomain.com"
EMAIL="fabian@fabian.com"

# Define absolute paths based on the user's home
CONFIG_DIR="${BASE_DIR}/config"
WORK_DIR="${BASE_DIR}/work"
LOGS_DIR="${BASE_DIR}/logs"

# --- Preparation ---
# Create the directory structure quietly
mkdir -p "$CONFIG_DIR" "$WORK_DIR" "$LOGS_DIR"

# --- Execution ---
echo "Initiating non-root Certbot run for ${DOMAIN}..."
echo "Files will be stored in: ${BASE_DIR}"

certbot certonly \
    --manual \
    --preferred-challenges dns \
    --agree-tos \
    --no-eff-email \
    -m "$EMAIL" \
    -d "$DOMAIN" \
    --config-dir "$CONFIG_DIR" \
    --work-dir "$WORK_DIR" \
    --logs-dir "$LOGS_DIR" \
    --manual-public-ip-logging-ok

# --- Verification ---
if [ -d "${CONFIG_DIR}/live" ]; then
    echo "Success! Your certificates are located in: ${CONFIG_DIR}/live/"
else
    echo "Check the logs in ${LOGS_DIR} if the challenge failed."
fi
