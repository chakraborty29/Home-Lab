# Ansible Home Lab Documentation

This documentation covers the Ansible automation for setting up and managing a home lab environment, including K3s cluster deployment and Traefik configuration.

## Repository Structure

The automation is split between two repositories:
1. Public repo (this one): Contains all playbooks and non-sensitive configurations
2. Private repo (home-lab-creds): Contains sensitive data, credentials, and secrets

### Public Repository Structure
```
ansible/
├── group_vars/
│ ├── all.yml # Common variables
│ ├── k3s.yml # K3s specific configurations
│ └── traefik.yml # Traefik configurations
├── playbooks/
│ ├── configure_builder_server.yml # Sets up the ansible builder
│ ├── deploy_traefik.yml # Deploys Traefik
│ ├── k3s_deploy.yml # Deploys K3s cluster
│ ├── k3s_destroy.yml # Destroys K3s cluster
│ ├── k3s_vms_create.yml # Creates/updates K3s VMs
│ └── k3s_vms_destroy.yml # Destroys K3s VMs
└── inventory # Main inventory file (copied from private repo)
```

### Private Repository Structure (home-lab-creds)
```
ansible/
├── group_vars/
│ ├── all/
│ │ └── secrets.yml # Repository URLs, SSH keys
│ ├── k3s/
│ │ └── secrets.yml # K3s sensitive configurations
│ └── traefik/
│ └── secrets.yml # Traefik user and path configurations
├── inventory/
│ ├── inventory # Main inventory file
│ └── k3s_inventory # K3s specific inventory
└── k3s/ # Terraform configurations for VMs
├── k3s-master-1.tfvars
├── k3s-master-2.tfvars
└── k3s-node-1.tfvars
```

## Initial Setup

1. Clone both repositories:
```bash
git clone git@github.com:your-username/Home-Lab.git
git clone git@github.com:your-username/home-lab-creds.git
```

2. Configure the builder server from your local machine:
```bash
cd Home-Lab/ansible
ansible-playbook playbooks/configure_builder_server.yml --extra-vars "local_credentials_path=~/path/to/home-lab-creds"
```


## Traefik Deployment

Deploy Traefik as your ingress controller:

```bash
ansible-playbook playbooks/deploy_traefik.yml
```


This will:
1. Create necessary directories
2. Copy configurations from public repo
3. Copy secrets from private repo
4. Set up Docker network
5. Deploy Traefik containers

## K3s Cluster Management

### Creating K3s VMs

You can create all VMs or target a specific VM:
```bash
# Create all VMs
ansible-playbook playbooks/k3s_vms_create.yml
# Create specific VM
ansible-playbook playbooks/k3s_vms_create.yml --extra-vars "target_vm=k3s-master-1"
```

### Deploying K3s

After VMs are created, deploy K3s:
```bash
ansible-playbook playbooks/k3s_deploy.yml
```

This will:
1. Wait for all nodes to be accessible
2. Deploy K3s using the k3s-ansible playbook

### Destroying K3s

To destroy the K3s cluster:
```bash
# irst, reset the K3s cluster
ansible-playbook playbooks/k3s_destroy.yml
# Then destroy the VMs
ansible-playbook playbooks/k3s_vms_destroy.yml
```

## Variable Management

### Public Variables
- `group_vars/all.yml`: Common variables like paths and repository configurations
- `group_vars/k3s.yml`: K3s specific configurations
- `group_vars/traefik.yml`: Traefik configurations

### Private Variables (in home-lab-creds)
- `group_vars/all/secrets.yml`: Repository URLs and SSH keys
- `group_vars/k3s/secrets.yml`: K3s sensitive data
- `group_vars/traefik/secrets.yml`: Traefik user and path configurations

## Maintenance Tasks

### Updating Builder Server
```bash
ansible-playbook playbooks/configure_builder_server.yml -t update
```


## Security Considerations

1. Keep the private repository secure - it contains:
   - SSH keys
   - Repository URLs
   - Sensitive configurations
   - Terraform variables

2. Use proper file permissions:
   - SSH keys: 0600
   - Configuration files: 0644
   - Directories: 0755

## Troubleshooting

1. Permission Issues:
   - Ensure proper ownership: `ansible_user`
   - Check directory permissions
   - Use `become: true` when needed

2. SSH Issues:
   - Verify SSH keys in private repo
   - Check SSH agent is running
   - Ensure proper key permissions

3. Terraform Issues:
   - Check tfvars files in private repo
   - Verify terraform initialization
   - Check Proxmox connectivity
