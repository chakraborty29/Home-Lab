# Home-Lab
This is the official repository for Raul's Home Lab Infrastructure, containing all the necessary configurations and code for a secure and efficient home laboratory setup.

[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://github.com/pre-commit/pre-commit)

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