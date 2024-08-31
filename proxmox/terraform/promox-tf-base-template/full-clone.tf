# Proxmox Full-Clone
# ---
# Create a new VM from a clone

resource "proxmox_vm_qemu" "your-vm" {
    
    # VM General Settings
    name = "${var.env}-${var.name}-${var.vmid}"
    target_node = "${var.target_node}"
    desc = "Created template by HasiCorp Terraform on ${timestamp()}."

    # VM Advanced General Settings
    onboot = true
    # vm_state = "stopped"
    
    disks {
        ide {
            ide3 {
                cloudinit {
                  storage = "local-lvm"
                }
            }
        }
        virtio {
            virtio0 {
                disk{
                    storage = "local-lvm"
                    size = "${var.size}"  # Set the storage size here
                }

            }
        }
    }


    # VM OS Settings
    scsihw = "virtio-scsi-pci"
    clone = "${var.clone}"
    boot = "order=virtio0"
    # bootdisk = "virtio0"

    # VM System Settings
    agent = 1
    
    # VM CPU Settings
    cores = "${var.cores}"
    sockets = 1
    cpu = "host"    
    
    # VM Memory Settings
    memory = "${var.memory}"

    # VM Network Settings
    network {
        bridge = "vmbr0"
        model  = "virtio"
    }

    # VM Cloud-Init Settings
    os_type = "cloud-init"

    # (Optional) IP Address and Gateway
    ipconfig0 = "${var.ipconfig0}"
    
    # (Optional) Default User
    ciuser = "${var.ciuser}"
    cipassword = "${var.cipassword}"
    
    # (Optional) Add your SSH KEY
    # sshkeys = <<EOF
    # #YOUR-PUBLIC-SSH-KEY
    # EOF
}