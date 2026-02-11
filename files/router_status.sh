#!/bin/bash

# --- CONFIGURATION ---
VPN_CONF="/etc/wireguard/wg0.conf"
VPN_IFACE="wg0"
PING_TARGET="1.1.1.1"

# Automatically find the Green Activity LED
LED_PATH=""
for led in /sys/class/leds/led0 /sys/class/leds/ACT; do
    if [ -d "$led" ]; then
        LED_PATH="$led"
        break
    fi
done

# Helper to set LED behavior
set_led() {
    # $1: trigger (none = solid, timer = blink)
    # $2: brightness (1 = on, 0 = off)
    if [ -n "$LED_PATH" ]; then
        echo "$1" > "$LED_PATH/trigger"
        if [ -n "$2" ]; then
            echo "$2" > "$LED_PATH/brightness"
        fi
    fi
}

# --- MAIN LOOP ---
while true; do
    # 1. Check Internet Connectivity
    if ping -c 1 -W 2 "$PING_TARGET" > /dev/null 2>&1; then
        NET_UP=true
    else
        NET_UP=false
    fi

    # 2. Check if VPN is Configured AND Active
    VPN_ACTIVE=false
    VPN_REQUIRED=false

    if [ -f "$VPN_CONF" ]; then
        # VPN config exists, so we MUST use it
        VPN_REQUIRED=true
        if ip link show "$VPN_IFACE" up > /dev/null 2>&1; then
            VPN_ACTIVE=true
        fi
    fi

    # --- DECISION LOGIC ---
    
    # CASE A: VPN is configured (High Security Mode)
    if [ "$VPN_REQUIRED" = true ]; then
        if [ "$VPN_ACTIVE" = true ] && [ "$NET_UP" = true ]; then
            # ✅ SECURE (VPN Up + Net Up) -> SOLID GREEN
            echo "none" > "$LED_PATH/trigger"
            echo "1" > "$LED_PATH/brightness"
        else
            # ⚠️ UNSAFE (VPN Down OR Net Down) -> BLINK
            echo "timer" > "$LED_PATH/trigger"
            echo 100 > "$LED_PATH/delay_on"
            echo 100 > "$LED_PATH/delay_off"
        fi

    # CASE B: No VPN configured (Standard Travel Router Mode)
    else
        if [ "$NET_UP" = true ]; then
            # ✅ ONLINE (Net Up) -> SOLID GREEN
            echo "none" > "$LED_PATH/trigger"
            echo "1" > "$LED_PATH/brightness"
        else
            # ❌ OFFLINE (Net Down) -> BLINK SLOWLY
            echo "timer" > "$LED_PATH/trigger"
            echo 500 > "$LED_PATH/delay_on"
            echo 500 > "$LED_PATH/delay_off"
        fi
    fi

    # Check again in 5 seconds
    sleep 5
done