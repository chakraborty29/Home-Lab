# Proxmox Provider
# ---
# Initial Provider Configuration for Proxmox

terraform {
    required_version = "~> 1.10.0"    # Allows any 1.9.x version
    required_providers {
        proxmox = {
            source = "telmate/proxmox"
            version = "3.0.1-rc3"
        }
    }
}

provider "proxmox" {

    pm_api_url = var.proxmox_api_url
    pm_api_token_id = var.proxmox_api_token_id
    pm_api_token_secret = var.proxmox_api_token_secret

    # (Optional) Skip TLS Verification
    pm_tls_insecure = true

}