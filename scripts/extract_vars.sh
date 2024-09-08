#!/bin/bash

# Read the SSH public key from the variables file
SSH_PUBLIC_KEY=$(awk -F' = ' '/ssh_authorized_key/ {gsub(/"/, "", $2); print $2}' variables.pkrvars.hcl)

# Replace the placeholder in the user-data file with the SSH public key
sed -i "s|your-ssh-key|$SSH_PUBLIC_KEY|" ./http/user-data