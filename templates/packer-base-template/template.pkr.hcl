# vm-pmx-hl-template-base
# ---
# Packer Template to create an Ubuntu Server (jammy) on Proxmox

packer {
  required_plugins {
    name = {
      version = "1.1.8"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

# Variable Definitions
######################################################################################################
######################################################################################################
variable "env" {
  type    = string
}

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

variable "proxmox_node" {
    type = string
}

variable "proxmox_iso_file" {
    type = string
}

variable "agent" {
    type = string
}

variable "vm_name" {
    type = string
}

variable "cores" {
    type = string
}

variable "memory" {
    type = string
}

variable "http_bind_address" {
    type = string
}

variable "http_bind_port" {
    type = string
}

variable "ssh_username" {
    type = string
}

variable "ssh_private_key_file" {
    type = string
}
######################################################################################################
######################################################################################################

# Resource Definiation for the VM Template
source "proxmox-iso" "vm-template" {
 
    # Proxmox Connection Settings
    proxmox_url = "${var.proxmox_api_url}"
    username = "${var.proxmox_api_token_id}"
    token = "${var.proxmox_api_token_secret}"
    # (Optional) Skip TLS Verification
    insecure_skip_tls_verify = true
    
    # VM General Settings
    node = "${var.proxmox_node}"
    vm_name = "${var.env}-${var.vm_name}-${var.agent}"
    template_description = "Created template by HasiCorp Packer on ${timestamp()}."

    # VM OS Settings
    # (Option 1) Local ISO File
    iso_file = "${var.proxmox_iso_file}"
    
    iso_storage_pool = "local"
    unmount_iso = true

    # VM System Settings
    qemu_agent = true

    # VM Hard Disk Settings
    scsi_controller = "virtio-scsi-pci"

    # Diable KVM Agent
    disable_kvm = false

    disks {
        disk_size = "20G"
        format = "raw"
        storage_pool = "local-lvm"
        // storage_pool_type = "lvmthin"
        type = "virtio"
    }

    # VM CPU Settings
    cores = "${var.cores}"
    
    # VM Memory Settings
    memory = "${var.memory}"

    # VM Network Settings
    network_adapters {
        model = "virtio"
        bridge = "vmbr0"
        firewall = "false"
    } 

    # VM Cloud-Init Settings
    cloud_init = true
    cloud_init_storage_pool = "local-lvm"

    # PACKER Boot Commands
    boot_command = [
        "<esc><wait><esc><wait>",
        "<f6><wait><esc><wait>",
        "<bs><bs><bs><bs><bs>",
        "autoinstall ds=nocloud-net;s=http://${var.http_bind_address}:${var.http_bind_port}/ ",
        "--- <enter>"
    ]
    boot = "c"
    boot_wait = "5s"

    # PACKER Autoinstall Settings
    http_directory = "http" 
    # (Optional) Bind IP Address and Port
    http_bind_address = "0.0.0.0"
    http_port_min = "${var.http_bind_port}"
    http_port_max = "${var.http_bind_port}"

    ssh_username = "${var.ssh_username}"

    # (Option 2) Add your Private SSH KEY file here

    # Use Docker to spin up the run file where the ssh key gets created in docker and then once the provisioning is done
    # we discard the docker deleting keys, making this secure
    ssh_private_key_file = "${var.ssh_private_key_file}"

    # Raise the timeout, when installation takes longer
    ssh_timeout = "120m"
}

# Build Definition to create the VM Template
build {
    
    name = "${var.env}-${var.vm_name}-${var.agent}"
    sources = ["source.proxmox-iso.vm-template"]

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #1
    provisioner "shell" {
        inline = [
            "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
            "sudo rm /etc/ssh/ssh_host_*",
            "sudo truncate -s 0 /etc/machine-id",
            "sudo apt -y autoremove --purge",
            "sudo apt -y clean",
            "sudo apt -y autoclean",
            "sudo cloud-init clean",
            "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
            "sudo rm -f /etc/netplan/00-installer-config.yaml",
            "sudo sync"
        ]
    }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #2
    provisioner "file" {
        source = "files/99-pve.cfg"
        destination = "/tmp/99-pve.cfg"
    }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #3
    provisioner "shell" {
        inline = [ "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg" ]
    }

    
    provisioner "file" {
        source = "files/scripts/docker_install.sh"
        destination = "/tmp/docker_install.sh"
    }

    provisioner "file" {
        source = "files/scripts/ansible_install.sh"
        destination = "/tmp/ansible_install.sh"
    }

    provisioner "file" {
        source = "files/scripts/terraform_install.sh"
        destination = "/tmp/terraform_install.sh"
    }

    provisioner "shell" {
        inline = [ 
            "chmod +x /tmp/docker_install.sh",
            "sudo /tmp/docker_install.sh" 
        ]
    }

    provisioner "shell" {
        inline = [ 
            "chmod +x /tmp/ansible_install.sh",
            "sudo /tmp/ansible_install.sh" 
        ]
    }

    provisioner "shell" {
        inline = [ 
            "chmod +x /tmp/terraform_install.sh",
            "sudo /tmp/terraform_install.sh" 
        ]
    }

}
