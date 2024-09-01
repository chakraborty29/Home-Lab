# Automating Proxmox VM Creation with Packer Scripts

### Essential Configuration mandatory across all environments
```
packer {
  required_plugins {
    name = {
      version = "1.1.8"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}
```
### Essential Configuration for Development Environment Testing
For development environments or when operating behind a corporate proxy, consider the following settings:
```
source "proxmox-iso" "vm-template" {
    ...

    // (Optional) Bypass TLS Verification
    insecure_skip_tls_verify = true

    ...
}
```

### Essential Configuration for proxmox-iso builder
Ensure the disk format is set to `raw` when utilizing a local ISO image from Proxmox. The `storage_pool_type` is deprecated and should be omitted:

```
source "proxmox-iso" "vm-template" {
    ...

    disks {
        disk_size = "20G"
        format = "raw"
        storage_pool = "local-lvm"
        // storage_pool_type = "lvmthin"
        type = "virtio"
    }

    ...
}
```

The subsequent boot commands are necessary for Packer to interact with Ubuntu servers:

#### For Ubuntu Focal - 20.04
```
source "proxmox-iso" "vm-template" {
    ...

    // PACKER Boot Commands
    boot_command = [
        "<esc><wait><esc><wait>",
        "<f6><wait><esc><wait>",
        "<bs><bs><bs><bs><bs>",
        "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ",
        "--- <enter>"
    ]

    ...
}
```

#### For Ubuntu Jammy 22.04
```
source "proxmox-iso" "vm-template" {
    ...

    // PACKER Boot Commands
    boot_command = [
        "<esc><wait>",
        "e<wait>",
        "<down><down><down><end>",
        "<bs><bs><bs><bs><wait>",
        "autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<wait>",
        "<f10><wait>"
    ]

    ...
}
```

If you encounter issues with `Packer` hosting the `user-data` for `cloud-init` or with `Proxmox` accessing your LAN, especially when using `WSL`, the following workaround may be necessary. Since Packer binds the HTTP server to the `WSL localhost` using `http_bind_address = "0.0.0.0"`, and Proxmox cannot access this address, you can **define a separate variable** for the address. This allows Packer to bind to the WSL localhost while Proxmox accesses the address from the external LAN. The address should correspond to the work machine running Packer.

```
    boot_command = [
        ...
        "autoinstall ds=nocloud-net;s=http://${var.http_bind_address}:${var.http_bind_port}/ ",
        ...
    ]
```

For WSL users, execute the following command in an **elevated** PowerShell session:

| :warning: WARNING          |
|:---------------------------|
| The following action is insecure and may expose your system to attacks if ports are left open:|


```
netsh interface portproxy add v4tov4 listenport=8802 listenaddress=0.0.0.0 connectport=8802 connectaddress=${WSL_MACHINE_IP}
```

To remove the port forwarding after use:
```
netsh interface portproxy delete v4tov4 listenport=8802 listenaddress=0.0.0.0
```

I have not yet found a secure solution for this.

### Example  vars.pkvars.hcl file:
```
env = "dev"
proxmox_api_url = "http://<proxmox-api-addr>/api2/json"  # Your Proxmox IP Address
proxmox_api_token_id = ""  # API Token ID
proxmox_api_token_secret = ""
proxmox_iso_file = "local:iso/ubuntu-20.04.6-live-server-amd64.iso"
proxmox_node = "dev-pve-01"
vm_name = ""
agent = "1"
cores = "1"
memory = "2048"
http_bind_address = ""
http_bind_port = ""
ssh_username = ""
ssh_private_key_file = "./files/ssh/id_rsa"
```

All that is left to do:
Validating with Packer:
```bash
packer validate -var-file='./vars.pkrvars.hcl' ./template.pkr.hcl
```
Building with Packer:
```bash
packer build -var-file='./vars.pkrvars.hcl' ./template.pkr.hcl
```

## To-dos: 

Create docs for use of proper user permission
```bash
pveum useradd packer@pve
pveum passwd packer@pve
pveum roleadd Packer -privs "VM.Config.Disk VM.Config.CPU VM.Config.Cloudinit VM.Config.Memory Datastore.AllocateSpace Sys.Audit Sys.Modify VM.Config.Options VM.Allocate VM.Audit VM.Console VM.Config.CDROM VM.Config.Network VM.PowerMgmt VM.Config.HWType VM.Monitor"
pveum aclmod / -user packer@pve -role Packer
```


# References
1. ***[Christian Lempa's](https://www.youtube.com/@christianlempa)***  - [boilerplates](https://github.com/ChristianLempa/boilerplates/tree/main/packer/proxmox)
2. [Proxmox: Create a cloud-init Template VM with Packer.](https://ronamosa.io/docs/engineer/LAB/proxmox-packer-vm/###ubuntu-server-focal.pkr.hcl)
3. [How to Use Packer and Subiquity on WSL2](https://chemejon.io/how-to-use-packer-and-subiquity-on-wsl2/)
4. [Packer Proxmox Templates](https://github.com/lkubb/packer-proxmox-templates)
5. [Microsoft WSL Networking Documentation](https://learn.microsoft.com/en-us/windows/wsl/networking)