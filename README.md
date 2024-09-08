# Home-Lab
This is the official repository for Raul's Home Lab Infrastructure, containing all the necessary configurations and code for a secure and efficient home laboratory setup.

[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://github.com/pre-commit/pre-commit)

## Why Build a Home Lab?
I have a passion for coding and creating things. While developing applications is fascinating, I've recently found myself drawn to the world of infrastructure. Visual design and front-end development were never my strong suits, but I've always excelled at back-end tasks, crafting APIs, and understanding the intricacies of infrastructure. After all, applications on the internet rely on robust infrastructure to function; when it fails, businesses grind to a halt, and money is lost. Even the most advanced app is of little use if it's not supported by secure, reliable infrastructure.

When I started out, I built a [Kubernetes Cluster using Raspberry Pis and Hyper-V virtual machines](https://github.com/chakraborty29/Personal-Projects/blob/main/kubernetes/setup-with-kubeadm.md). It was a learning curve, full of mistakes that forced me to tediously rebuild VMs from scratch. At the time, I didn't know how to automate this process, but eventually, I succeeded in setting up a Kubernetes Cluster, hosting a website, and making it accessible from an external network. That achievement filled me with pride and helped me land my second internship as a DevOps Engineer. That's where I was introduced to automation tools like Terraform and Packer.

Two years on, I've finally had the chance to dive back in. My toolkit now includes Proxmox for virtualization, Packer for automating VM builds, and Terraform for deploying them. With the groundwork laid, I'm excited to continue expanding my home lab.

Here are a few features I envision for my home lab:

1. A Kubernetes Cluster to run my applications.
2. A Jenkins setup for CI/CD processes (potentially integrated within Kubernetes).
3. A VPN Service to ensure secure remote access into my network.
4. Developing my own internal SSO Client to streamline authentication.

### Current State Architecture
![Alt Text](https://raw.githubusercontent.com/username/repository/develop/docs/src/current-state-architecture.png)

## Getting Started


### Prerequisites
Before initiating the build process, ensure the following prerequisites are met:
* Proxmox Node(s) are set up and operational.
* Ubuntu ISO is uploaded to the Proxmox Node(s).
* Proxmox API Token is created (Docmentation will be updated to include this step).
* Packer & Terraform are installed on the host machine.

### Building a Packer Image Template
1. Copy `template/packer-base-template` directory.
2. Navigate to the `files/ssh` directory and generate SSH keys for the cloudinit-admin user:
```bash
ssh-keygen -t rsa -b 4096 -C "cloudinit-admin" -f ./cloudinit_id_rsa
```
3. Rename `vars.hcl` to `vars.pkvars.hcl` and update it with your specific variables. Please refer to the [README.md](https://github.com/chakraborty29/Home-Lab/tree/develop/templates/packer-base-template) in the `templates/packer-base-template` directory about detailed information on the bind_address variable as it is critical for your Proxmox and Host machines to communicate for `cloud-init`.
5. Validate the Packer configuration:
```bash
packer validate -var-file='./vars.pkrvars.hcl' ./template.pkr.hcl
```
6. Build the Packer image template:
```bash
packer build -var-file='./vars.pkrvars.hcl' ./template.pkr.hcl
```

### Deploying a VM with Terraform
Once you built the image template with Packer, you can now clone that template and build VMs really quickly.
1. Copy `template/terraform-base-template` directory.
2. Update the variables in `credentials.tfvars` according to your requirements. You can omit the `ipconfig0` variable if you want DHCP to take care of the ip address assignment.
3. Plan the Terraform deployment:
```bash
terraform plan -var-file='./credentials.tfvars'
```
4. Apply the Terraform configurations:
```bash
terraform apply -var-file='./credentials.tfvars'
```
6. To remove the deployed infrastructure, use Terraform destroy:
```bash
terraform destroy -var-file='./credentials.tfvars'
```

## Integration of [pre-commit](https://pre-commit.com/) Framework for Enhanced DevSecOps Practices
### Purpose
Infrastructure as Code (IaC) repositories are inherently sensitive due to the presence of **secrets** and configuration files in formats such as `.yml`. They often interact with a variety of IaC tools, including but not limited to `Terraform`, `Packer`, `Kubernetes`, and `Docker`. The primary objective is to safeguard these secrets and prevent the deployment of insecure infrastructure by adhering to robust DevSecOps practices.

### What is [pre-commit](https://pre-commit.com/)?
[pre-commit](https://pre-commit.com/) is a framework that utilizes Git hooks to perform checks on code prior to submission for code review. It is instrumental in detecting potential issues such as exposed secrets, improper file formats, and vulnerabilities within IaC.

### Installed Hooks
1. **[yamlint](https://github.com/adrienverge/yamllint)**: Enforces best practices and linting for `.yml` files.
2. **[gitguardian](https://github.com/gitguardian/ggshield)**: Scans for exposed secrets within the codebase.

### System Requirements:
1. **[Python3](https://wiki.python.org/moin/BeginnersGuide/Download)**: Required for running pre-commit and associated hooks.

### Installation

Just run make :)
```bash
make
```

### Additional Utility Commands
1. Update pre-commit hooks to the latest versions:
    ```bash
    make autoupdate
    ```
2. Execute hooks against all files **(Note: By default, hooks are triggered during commit operations and only on the staged files)**:
    ```bash
    make run-all-files
    ```
3. Remove installed hooks **(Note: You will need to run `make` again to reinstall pre-commit and the hooks)**:
    ```bash
    make clean
    ```