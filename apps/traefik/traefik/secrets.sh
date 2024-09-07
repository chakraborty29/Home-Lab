#!/bin/bash

# source file
# source .traefik-secrets.sh 
# Define the secrets and config YAML files
SECRETS_FILE="./data/secrets.yml"
CONFIG_FILE="./data/config.yml"
DOCKER_COMPOSE_FILE="./docker-compose.yml"

# Function to extract a value from the YAML file
extract_value() {
    local key="$1"
    awk -F': ' -v key="$key" '$1 == key {gsub(/"/, "", $2); print $2}' "$SECRETS_FILE"
}

PVE1_DOMAIN_NAME=$(extract_value "PVE1_DOMAIN_NAME")
PVE2_DOMAIN_NAME=$(extract_value "PVE2_DOMAIN_NAME")
PVE3_DOMAIN_NAME=$(extract_value "PVE3_DOMAIN_NAME")
PVE_DOMAIN_NAME=$(extract_value "PVE_DOMAIN_NAME")
PIHOLE_DOMAIN_NAME=$(extract_value "PIHOLE_DOMAIN_NAME")
PIHOLE_IP_ADDRESS=$(extract_value "PIHOLE_IP_ADDRESS")
OPNSENSE_DOMAIN_NAME=$(extract_value "OPNSENSE_DOMAIN_NAME")
OPNSENSE_IP_ADDRESS=$(extract_value "OPNSENSE_IP_ADDRESS")
CF_API_EMAIL=$(extract_value "CF_API_EMAIL")
CF_API_KEY=$(extract_value "CF_API_KEY")
TRAEFIK_USER=$(extract_value "TRAEFIK_USER")
TRAEFIK_DOMAIN=$(extract_value "TRAEFIK_DOMAIN")
TRAEFIK_PASS=$(extract_value "TRAEFIK_PASS")
TRAEFIK_CREDS=$(extract_value "TRAEFIK_CREDS")
DEV_DOMAIN=$(extract_value "DEV_DOMAIN")

# Replace placeholders in the config file with the actual values in place
sed -i -e "s|{pve1-domain-name}|$PVE1_DOMAIN_NAME|g" \
       -e "s|{pve2-domain-name}|$PVE2_DOMAIN_NAME|g" \
       -e "s|{pve3-domain-name}|$PVE3_DOMAIN_NAME|g" \
       -e "s|{pve-domain-name}|$PVE_DOMAIN_NAME|g" \
       -e "s|{pihole-domain-name}|$PIHOLE_DOMAIN_NAME|g" \
       -e "s|{pihole-ip-address}|$PIHOLE_IP_ADDRESS|g" \
       -e "s|{opnsense-domain-name}|$OPNSENSE_DOMAIN_NAME|g" \
       -e "s|{opnsense-ip-address}|$OPNSENSE_IP_ADDRESS|g" \
       "$CONFIG_FILE"

echo "Configuration updated in $CONFIG_FILE."

sed -i -e "s|{CF_API_EMAIL}|$CF_API_EMAIL|g" traefik.yml

echo "Configuration updated in traefik.yml."

sed -i -e "s|{CF_API_EMAIL}|$CF_API_EMAIL|g" \
       -e "s|{CF_API_KEY}|$CF_API_KEY|g" \
       -e "s|{TRAEFIK_CREDS}|$TRAEFIK_CREDS|g" \
       -e "s|{TRAEFIK_CREDS}|$TRAEFIK_CREDS|g" \
       -e "s|{TRAEFIK_DOMAIN}|$TRAEFIK_DOMAIN|g" \
       -e "s|{DEV_DOMAIN}|$DEV_DOMAIN|g" \
       "$DOCKER_COMPOSE_FILE"

echo "Configuration updated in $DOCKER_COMPOSE_FILE."

echo "Secrets updated in Docker."