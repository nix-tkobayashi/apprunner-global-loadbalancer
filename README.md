# apprunner-global-loadbalancer
Provides Terraform code for global load balancing of applications deployed with the AWS App Runner service.

## System Requirements

- Terraform v1.3.9
- Docker 20.10.17


## Installation

1. clone this repository.

```bash
$ git clone https://github.com/nix-tkobayashi/apprunner-global-loadbalancer.git
```

2. Set the backend configuration to nginx. 

$ cd apprunner-global-loadbalancer/apps
# Set up the "server" portion of the "upstream backend"
$ vi nginx.conf


3. deploy the AWS resource using Terraform.

```bash
$ cd apprunner-global-loadbalancer/terraform
$ terraform init
$ terraform plan
$ terraform apply
```

## Example usage

Access the domain that appears in Terraform's apply results.


## License information

This repository is released under the MIT License. See [LICENSE](LICENSE) for more information.


