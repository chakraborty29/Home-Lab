# Home-Lab
Raul's Home Lab Scripts and Configs

## Implementing pre-commit security to establish good DevSecOps Practice
### PR #1 - [feature/implement-dpe-pre-commit-security](https://github.com/chakraborty29/Home-Lab/pull/1)

**Why?** - This project will deal with `.yaml` files, secrets and IaC such as `Terraform`, `Packer`, `Kubernetes` & `Docker`.

### What is [pre-commit](https://pre-commit.com/)?
Git hook scripts that are useful for identifying issues before submission to code review, such as exposed secrets, bad file formats and insecure IaC.

### Installed Hooks
1. [yamlint](https://github.com/adrienverge/yamllint.git) - For linting and developing best practices for YAML files.
2. [Tailsman](https://thoughtworks.github.io/talisman/) - For identifying exposed secrets.
3. [KICS](https://kics.io/) - For identifying insecure IaC.
