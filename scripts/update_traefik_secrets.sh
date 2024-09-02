#!/bin/bash

# source file
source .traefik-secrets.sh
# Define the secrets and config YAML files
CONFIG_FILE="config.yml"

# Replace placeholders in the config file with the actual values in place
sed -i -e "s|{pve1-domain-name}|$PVE1_DOMAIN_NAME|g" \
       -e "s|{pve2-domain-name}|$PVE2_DOMAIN_NAME|g" \
       -e "s|{pve3-domain-name}|$PVE3_DOMAIN_NAME|g" \
       -e "s|{pve-domain-name}|$PVE_DOMAIN_NAME|g" \
       -e "s|{pihole-domain-name}|$PIHOLE_DOMAIN_NAME|g" \
       -e "s|{pihole-ip-address}|$PIHOLE_IP_ADDRESS|g" \
       -e "s|{opnsense-domain-name}|$OPNSENSE_DOMAIN_NAME|g" \
       -e "s|{opnsense-ip-address}|$OPNSENSE_IP_ADDRESS|g" \
       config.yml

sed -i -e "s|{CF_API_EMAIL}|$CF_API_EMAIL|g" traefik.yml

echo "Configuration updated in $CONFIG_FILE."

TRAEFIK_CREDS=$(echo $(htpasswd -nB "$TRAEFIK_USER" "$TRAEFIK_PASS") | sed -e s/\\$/\\$\\$/g)

for var in CF_API_KEY CF_API_EMAIL TRAEFIK_USER TRAEFIK_DOMAIN TRAEFIK_CREDS DEV_DOMAIN; do echo "${!var}" | docker secret create "$var" -; done

echo "Secrets updated in Docker."