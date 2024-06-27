# Home-Lab
This is the official repository for Raul's Home Lab Infrastructure, containing all the necessary configurations and code for a secure and efficient home laboratory setup.

[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://github.com/pre-commit/pre-commit)

## Why Build a Home Lab?
I have a passion for coding and creating things. While developing applications is fascinating, I've recently found myself drawn to the world of infrastructure. Visual design and front-end development were never my strong suits, but I've always excelled at back-end tasks, crafting APIs, and understanding the intricacies of infrastructure. After all, applications on the internet rely on robust infrastructure to function; when it fails, businesses grind to a halt, and money is lost. Even the most advanced app is of little use if it's not supported by secure, reliable infrastructure.

When I started out, I built a [Kubernetes Cluster using Raspberry Pis and Hyper-V virtual machines](https://github.com/chakraborty29/Personal-Projects/blob/main/kubernetes/setup-with-kubeadm.md). It was a learning curve, full of mistakes that forced me to tediously rebuild VMs from scratch. At the time, I didn't know how to automate this process, but eventually, I succeeded in setting up a Kubernetes Cluster, hosting a website, and making it accessible from an external network. That achievement filled me with pride and helped me land my second internship as a DevOps Engineer. That's where I was introduced to automation tools like Terraform and Packer.

Two years on, I've finally had the chance to dive back in. My toolkit now includes Proxmox for virtualization, Packer for automating VM builds, and Terraform for deploying them. With the groundwork laid, I'm excited to continue expanding my home lab.

Here are a few features I envision for my home lab:

1. A Firewall to secure my network.
2. A VPN Service to ensure secure remote access and secure internet surfing.
3. A Kubernetes Cluster to run my applications.
4. A Jenkins setup for CI/CD processes (potentially integrated within Kubernetes).
5. **In the future:** developing my own internal SSO Client to streamline authentication.


## Integration of [pre-commit](https://pre-commit.com/) Framework for Enhanced DevSecOps Practices
### Purpose
Infrastructure as Code (IaC) repositories are inherently sensitive due to the presence of **secrets** and configuration files in formats such as `.yaml`. They often interact with a variety of IaC tools, including but not limited to `Terraform`, `Packer`, `Kubernetes`, and `Docker`. The primary objective is to safeguard these secrets and prevent the deployment of insecure infrastructure by adhering to robust DevSecOps practices.

### What is [pre-commit](https://pre-commit.com/)?
[pre-commit](https://pre-commit.com/) is a framework that utilizes Git hooks to perform checks on code prior to submission for code review. It is instrumental in detecting potential issues such as exposed secrets, improper file formats, and vulnerabilities within IaC.

### Installed Hooks
1. **[yamlint](https://github.com/adrienverge/yamllint)**: Enforces best practices and linting for `.yaml` files.
2. **[gitleaks](https://github.com/gitleaks/gitleaks)**: Scans for exposed secrets within the codebase.
3. **[KICS](https://kics.io/)**: Identifies security vulnerabilities in IaC.

### System Requirements:
1. **[Python3](https://wiki.python.org/moin/BeginnersGuide/Download)**: Required for running pre-commit and associated hooks.
2. **[Docker](https://docs.docker.com/engine/install/)**: Necessary for containerization and executing certain hooks.

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