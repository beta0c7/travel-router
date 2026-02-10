#!/bin/bash

# Stop on errors
set -e

# --- 1. USER INPUT SECTION ---
echo "=========================================="
echo " 🚀 TRAVEL ROUTER SETUP "
echo "=========================================="
echo "This script will configure your Raspberry Pi."
echo "Please enter the configuration details below."
echo ""

# Ask for WiFi SSID
read -p "Enter WiFi Name (SSID): " USER_SSID

# Ask for WiFi Password (Silent input)
read -s -p "Enter WiFi Password (min 8 chars): " USER_PASS
echo "" # Necessary to move to a new line after silent input

# Ask for Channel (Default to 36)
read -p "Enter WiFi Channel (default: 36): " USER_CHANNEL
USER_CHANNEL=${USER_CHANNEL:-36}

# Ask for Country Code (Default to US)
read -p "Enter Country Code (default: US): " USER_COUNTRY
USER_COUNTRY=${USER_COUNTRY:-US}

echo ""
# Ask for RaspAP Admin Password (Silent input)
read -s -p "Enter New Admin Web Password (default: secret): " ADMIN_PASS
echo "" 
ADMIN_PASS=${ADMIN_PASS:-secret}

echo ""
echo "------------------------------------------"
echo "Configuring: $USER_SSID (Channel: $USER_CHANNEL)"
echo "------------------------------------------"
sleep 2

# --- 2. INSTALLATION SECTION ---

echo "--- 📦 Installing Dependencies ---"
sudo apt-get update
sudo apt-get install -y git ansible

# Define where to download the code
REPO_DIR="/tmp/travel-router-install"
if [ -d "$REPO_DIR" ]; then
    sudo rm -rf "$REPO_DIR"
fi

echo "--- 📥 Cloning Repository ---"
# *** IMPORTANT: Replace YOUR_GITHUB_USER below ***
# If your repo is Private, use: https://TOKEN@github.com/...
git clone https://github.com/YOUR_GITHUB_USER/travel-router.git $REPO_DIR

# --- 3. EXECUTION SECTION ---
echo "--- ⚙️  Running Configuration Playbook ---"
cd $REPO_DIR

# Run Ansible and pass the variables we captured above
sudo ansible-playbook router_setup.yaml --extra-vars "wifi_ssid='$USER_SSID' wifi_password='$USER_PASS' wifi_channel='$USER_CHANNEL' country_code='$USER_COUNTRY' admin_password='$ADMIN_PASS'"

echo "--- ✅ INSTALLATION COMPLETE! Rebooting in 5 seconds... ---"
sleep 5
sudo reboot