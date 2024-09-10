#!/bin/bash

SECRETS_FILE="../vars/k3s.yml"

extract_value() {
    local key="$1"
    awk -F': ' -v key="$key" '$1 == key {gsub(/"/, "", $2); print $2}' "$SECRETS_FILE"
}

K3S_TOKEN=$(extract_value "K3S_TOKEN")

sed -i -e "s|{k3_token}|$K3S_TOKEN|g" /home/ansible/k3s-ansible/inventory/my-cluster/group_vars/all.yml