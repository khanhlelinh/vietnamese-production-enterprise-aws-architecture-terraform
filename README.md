# Vietnamese Production AWS Architecture

* [![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
* [![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
* [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
* [![CI](https://img.shields.io/badge/CI-Passing-brightgreen.svg?style=for-the-badge)](https://github.com/)

A practical Terraform architecture that I put together for our production workloads.

## Table of Contents
- [Architecture Overview](#architecture-overview)
- [Quick Start](#quick-start)
- [Environments](#environments)
- [Modules](#modules)

## Architecture Overview
I built this repository to define our AWS architecture for Vietnamese production environments. It should provide a solid baseline for deploying our apps.

## Quick Start
You can easily spin this up by running:
```bash
make init
make plan
make apply
```

## Environments
I've set up three main environments:
- Dev
- Staging
- Prod

## Modules
Take a look at the `modules/` directory for my documentation on individual modules.
