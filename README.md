# 🌍 Raspberry Pi Travel Router (Ansible)

This repository contains an automated setup script to turn a stock Raspberry Pi into a high-performance **Travel Router**.

It uses **Ansible** to configure a headless Raspberry Pi that automatically connects to your phone's hotspot (or hotel WiFi) and rebroadcasts it as a private, secure, high-speed WiFi network for all your devices.

## 🚀 Why Use This?
When traveling, connecting multiple devices (laptop, tablet, Kindle, Nintendo Switch) to hotel WiFi or a phone hotspot is painful.
* **Hotel WiFi:** Often limits the number of devices or requires a captive portal login on every single screen.
* **Phone Hotspot:** Drains battery and often has poor range or device limits.

**This Travel Router solves that:**
1.  **One Connection:** You only connect the Pi to the internet (Hotel/Phone).
2.  **Private Network:** All your devices connect to the Pi once and never need to be reconfigured.
3.  **Bypassing Limits:** The hotel sees only *one* device (the Pi).
4.  **VPN Ready:** (Optional) You can easily add WireGuard/OpenVPN to secure all traffic.
5.  **Ad Blocking:** (Optional) Includes ad-blocking DNS capabilities via RaspAP.

## ✨ Features
* **Fully Automated Setup:** One command installs everything.
* **Dual-Band WiFi:** Configured for high-performance 5GHz (80MHz width) AC/WiFi 5.
* **Auto-Connect:** Automatically connects to your saved hotspots (iPhone/Android) on boot.
* **Status LEDs:**
    * **Solid Green/Red:** Internet Connected.
    * **Blinking:** Searching for Internet.
* **Hardware RTC Support:** Automatically configures DS3231 I2C Real-Time Clock for offline timekeeping.
* **Security:** Forces WPA2-AES encryption and changes default passwords.
* **Admin Interface:** Includes **RaspAP** web GUI for easy management (`10.3.141.1`).

## 🛠️ Hardware Requirements
* **Raspberry Pi 4 / 5** (Recommended for Gigabit speed).
* **microSD Card** (8GB+).
* **USB WiFi Adapter** (Optional, for better range/dual-radio support).
    * *Note: Scripts are optimized for BrosTrend/Realtek drivers but work with standard kernel drivers too.*
* **(Optional)** DS3231 RTC Module (for accurate time when offline).

## 📥 Installation

1.  **Flash your SD Card** with **Raspberry Pi OS Lite (64-bit)** using Raspberry Pi Imager.
2.  **Boot the Pi** and connect it to the internet (Ethernet is recommended for initial setup).
3.  **SSH into the Pi** and run this one-line installer:

```bash
curl -L https://raw.githubusercontent.com/beta0c7/travel-router/master/setup.sh | sudo bash