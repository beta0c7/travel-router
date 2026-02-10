#!/bin/bash

# Stop on errors
set -e

echo "=========================================="
echo " 🚀 TRAVEL ROUTER SETUP "
echo "=========================================="
echo "This script will configure your Raspberry Pi."
echo ""

# --- 1. PROMPT FOR USER INPUT (Fix: Read from TTY) ---

# 1. WiFi SSID (Name)
# We force input from /dev/tty so it works with curl | bash
read -p "Enter WiFi Name (SSID): " USER_SSID < /dev/tty

# 2. WiFi Password (Silent)
read -s -p "Enter WiFi Password (min 8 chars): " USER_PASS < /dev/tty
echo ""

# 3. WiFi Channel
read -p "Enter WiFi Channel (default: 36): " USER_CHANNEL < /dev/tty
USER_CHANNEL=${USER_CHANNEL:-36}

# 4. Country Code
read -p "Enter Country Code (default: US): " USER_COUNTRY < /dev/tty
USER_COUNTRY=${USER_COUNTRY:-US}

# 5. Admin Password (Silent)
read -s -p "Enter New Admin Web Password (default: secret): " ADMIN_PASS < /dev/tty
echo ""
ADMIN_PASS=${ADMIN_PASS:-secret}

echo "------------------------------------------"
echo "✅ Configuration Locked In:"
echo "   Network: $USER_SSID"
echo "   Channel: $USER_CHANNEL"
echo "------------------------------------------"
sleep 2

# --- 2. INSTALLATION ---

echo "--- 📦 Installing Dependencies ---"
sudo apt-get update
sudo apt-get install -y git ansible

# Define download location
REPO_DIR="/tmp/travel-router-install"

if [ -d "$REPO_DIR" ]; then
    sudo rm -rf "$REPO_DIR"
fi

echo "--- 📥 Cloning Repository (beta0c7) ---"
git clone https://github.com/beta0c7/travel-router.git $REPO_DIR

# --- 3. EXECUTION ---

echo "--- ⚙️  Running Configuration Playbook ---"
cd $REPO_DIR

# Run Ansible with the variables we captured above
sudo ansible-playbook router_setup.yaml --extra-vars "wifi_ssid='$USER_SSID' wifi_password='$USER_PASS' wifi_channel='$USER_CHANNEL' country_code='$USER_COUNTRY' admin_password='$ADMIN_PASS'"

echo "--- ✅ INSTALLATION COMPLETE! Rebooting in 5 seconds... ---"
sleep 5
sudo reboot