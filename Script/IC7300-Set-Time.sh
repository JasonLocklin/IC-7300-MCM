#!/bin/bash

#####################################
# Icom IC-7300 Time Synchronization #
#####################################

# Description:
# This script sets the time on an Icom IC-7300 radio via the specified USB serial interface.
# It calculates the date, time, and relevant hex values before sending the commands to the radio.

# Check if $baudrate and $device_file already exist as environment variables
if [ -z "$baudrate" ]; then
    baudrate=9600
fi

if [ -z "$device_file" ]; then
    device_file="/dev/serial/by-id/usb-Silicon_Labs_CP2102_USB_to_UART_Bridge_Controller_IC-7300_02040476-if00-port0"
fi

preamble="FEFE94E01A0500"
responseOk="FEFEE094FBFD" # Expected response from the radio

# Function for converting decimal to hex
hexInt() {
    printf "0x%02X" $1
}

# Function to send a command to the radio
sendCommand() {
    local command="$1"
    local data="$2"

    # Open the serial port
    stty_output=$(stty -F "$device_file" "$baudrate" 2>&1)
    if [ $? -ne 0 ]; then
        echo "Error: Unable to set baud rate. $stty_output"
        exit 1
    fi

    exec 3<>"$device_file"
    if [ $? -ne 0 ]; then
        echo "Error: Unable to open serial port $device_file."
        exit 1
    fi

    # Construct the command
    local fullCommand="$preamble$command$data\xFD"

    # Write the command to the serial port
    printf "$fullCommand" >&3

    # Wait for a short time to ensure the command is sent
    sleep 0.1

    # Read the response
    read -t 5 response <&3

    # Check if the response is okay
    if [ "$response" != "$responseOk" ]; then
        echo "Error: Command $fullCommand did not receive OK from radio."
        exit 4
    fi

    # Close the serial port
    exec 3<&-
    exec 3>&-
}

# Wait for the beginning of the next minute
while true; do
    sleep 0.1
    now=$(date +'%S')
    if [ "$now" -eq 0 ]; then
        break
    fi
done

# Set the date
year=$(date +'%Y')
month=$(date +'%m')
day=$(date +'%d')

y1=$(hexInt $((year / 100)))
y2=$(hexInt $((year % 100)))
m=$(hexInt $month)
d=$(hexInt $day)

sendCommand "94" "$y1$y2$m$d" # Set date

# Set the time
hour=$(date +'%H')
minute=$(date +'%M')

h=$(hexInt $hour)
m=$(hexInt $minute)

sendCommand "95" "$h$m" # Set time

echo "Time set successfully"

