#!/usr/bin/env bash
#Author:    Anonymous (@Anonymous4717)
#Date:      15 jan 2024
#Desc:      Script used to process a PCAP file with Arkime (formerly Moloch)

PCAP=$1

# Ensure there is at least one argument
if [ $# -eq 0 ]; then
    echo "[!] Usage: $0 'path to PCAP file'"; 
    exit 1;
fi

# Test if file exists
if [ ! -f "$PCAP" ]; then
    echo "[!] PCAP file doesn't exist, please provide a valid path to your PCAP"
    exit 1;
fi

# clear Arkime
echo "[*] Clearing previous Arkime data..."
printf 'WIPE\n' | /opt/arkime/db/db.pl http://localhost:9200 wipe > /dev/null
rm -f /opt/arkime/raw/*

# process PCAP
echo "[*] Capturing new PCAP..."
/opt/arkime/bin/capture -r ${1} -t $(echo ${1}) > /dev/null

# Restart Arkime Viewer - artifacts from previous PCAPs linger if you don't do this
echo "[*] Restarting Arkime Viewer..."
sudo systemctl restart arkimeviewer.service

# Done!
echo "[*] Complete - please allow a brief period for data to populate"
