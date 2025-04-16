variable "proxmox_api_url" {
    type = string
}

variable "proxmox_api_token_id" {
    type = string
}

variable "proxmox_api_token_secret" {
    type = string
    sensitive = true
}

variable "env" {
    type = string
}


variable "target_node" {
    type = string
}

variable "agent" {
    type = string
}

variable "name" {
    type = string
}

variable "size" {
    type = string
}

variable "clone" {
    type = string
}

variable "cores" {
    type = string
}

variable "memory" {
    type = string
}

variable "ipconfig0" {
    type = string
}

variable "ciuser" {
    type = string
}

# variable "cipassword" {
#     type = string
#     sensitive = true
# }