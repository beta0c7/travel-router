#!/bin/bash

# --- CONFIGURATION ---
# Green LED (Activity)
GREEN_LED="/sys/class/leds/ACT"
# Red LED (Power) - Note: This disables the undervoltage warning!
RED_LED="/sys/class/leds/PWR"

# Function to check internet
check_internet() {
    # Ping Google DNS. Returns 0 if successful.
    ping -q -c 1 -W 2 8.8.8.8 > /dev/null
}

# Initial setup: Reset triggers for both
echo none | sudo tee $GREEN_LED/trigger > /dev/null
echo none | sudo tee $RED_LED/trigger > /dev/null

while true; do
    if check_internet; then
        # --- CONNECTED (BOTH SOLID ON) ---
        
        # Check current trigger to avoid unnecessary writes
        current_trigger=$(cat $GREEN_LED/trigger | grep -o "\[none\]")
        
        if [ -z "$current_trigger" ]; then
             # Set Green to Solid
             echo none | sudo tee $GREEN_LED/trigger > /dev/null
             echo 1 | sudo tee $GREEN_LED/brightness > /dev/null
             
             # Set Red to Solid
             echo none | sudo tee $RED_LED/trigger > /dev/null
             echo 1 | sudo tee $RED_LED/brightness > /dev/null
        else
             # Ensure they stay bright (Red sometimes defaults to off if touched)
             echo 1 | sudo tee $GREEN_LED/brightness > /dev/null
             echo 1 | sudo tee $RED_LED/brightness > /dev/null
        fi
        
    else
        # --- DISCONNECTED (BOTH FAST BLINK) ---
        
        current_trigger=$(cat $GREEN_LED/trigger | grep -o "\[timer\]")
        
        if [ -z "$current_trigger" ]; then
            # Set Green to Blink
            echo timer | sudo tee $GREEN_LED/trigger > /dev/null
            echo 200 | sudo tee $GREEN_LED/delay_on > /dev/null
            echo 200 | sudo tee $GREEN_LED/delay_off > /dev/null
            
            # Set Red to Blink
            echo timer | sudo tee $RED_LED/trigger > /dev/null
            echo 200 | sudo tee $RED_LED/delay_on > /dev/null
            echo 200 | sudo tee $RED_LED/delay_off > /dev/null
        fi
    fi
    
    # Wait 5 seconds before checking again
    sleep 5
done

