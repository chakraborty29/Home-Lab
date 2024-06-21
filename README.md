# Home-Lab
Raul's Home Lab Scripts and Configs

## KICS Workaround with Custom Local Hook

**Why?** - If you are not able to pull the [checkmarx/kics](https://hub.docker.com/r/checkmarx/kics#!) docker image, or are having trouble bulding docker image due to custom certificates and proxy, this workaround will allow you to copy over your custom certificate into a docker container to build and run [KICS](https:??kics.io/).

### Know Issues
1. **Security**: This hook is insecurely copying over certificates into the docker container.
2. **Large Image Files**: This hook creates a 5gb image just to run a KICS scan.
3. **Slow**: Intitial buildtime takes very long, at a minimum 5 minutes. 

### What is [pre-commit](https://pre-commit.com/)?
Git hook scripts that are useful for identifying issues before submission to code review, such as exposed secrets, bad file formats and insecure IaC.

### Installed Hooks
1. [yamlint](https://github.com/adrienverge/yamllint.git) - For linting and developing best practices for YAML files.
2. [Tailsman](https://thoughtworks.github.io/talisman/) - For identifying exposed secrets.
3. [KICS](https://kics.io/) - For identifying insecure IaC.
