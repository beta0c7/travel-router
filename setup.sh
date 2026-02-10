#!/bin/bash

# Stop on errors
set -e

echo "=========================================="
echo " 🚀 TRAVEL ROUTER SETUP "
echo "=========================================="
echo "This script will configure your Raspberry Pi."
echo "Please enter the configuration details below."
echo ""

# 1. Prompt for User Input
read -p "Enter WiFi Name (SSID): " USER_SSID
read -s -p "Enter WiFi Password (min 8 chars): " USER_PASS
echo ""
read -p "Enter WiFi Channel (default 36): " USER_CHANNEL
USER_CHANNEL=${USER_CHANNEL:-36} # Default to 36 if empty
read -p "Enter Country Code (default US): " USER_COUNTRY
USER_COUNTRY=${USER_COUNTRY:-US} # Default to US if empty

echo ""
read -s -p "Enter New Admin Web Password (default: secret): " ADMIN_PASS
ADMIN_PASS=${ADMIN_PASS:-secret} # Default to 'secret' if empty

echo ""
echo "------------------------------------------"
echo "Configuring: $USER_SSID (Channel: $USER_CHANNEL)"
echo "------------------------------------------"
sleep 2

# 2. Install Dependencies
echo "--- 📦 Installing Dependencies ---"
sudo apt-get update
sudo apt-get install -y git ansible

# 3. Clone Repo (Safety Check)
REPO_DIR="/tmp/travel-router-install"
if [ -d "$REPO_DIR" ]; then
    sudo rm -rf "$REPO_DIR"
fi

# REPLACE THIS URL WITH YOUR PUBLIC REPO URL
echo "--- 📥 Cloning Repository ---"
git clone https://github.com/YOUR_GITHUB_USER/travel-router.git $REPO_DIR

# 4. Run Ansible with Variables
echo "--- ⚙️  Running Configuration Playbook ---"
cd $REPO_DIR

sudo ansible-playbook router_setup.yaml --extra-vars "wifi_ssid='$USER_SSID' wifi_password='$USER_PASS' wifi_channel='$USER_CHANNEL' country_code='$USER_COUNTRY'"

echo "--- ✅ INSTALLATION COMPLETE! Rebooting in 5 seconds... ---"
sleep 5
sudo reboot