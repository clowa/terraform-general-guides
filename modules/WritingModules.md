# How to write terraform modules
_inspired by Yevgeniy Brinkmans "Terraform: Up and Running"_

## The golden rule of  terraform
*The master branch of the _live_ repository should be a 1:1 representation of what's actually deployed in production.*

## Production-grade modules - Step by step
1. Go through the [production-grade infrastructure checklist](#production-grade-infrastructure-checklist) and explicitly identify the items you'll be implementing and the items you'll be skipping.
2. Use the result of this checklist of Step 1, plus the [time estimation Table](#how-long-it-takes-to-build-production-grade-infrastructure-from-scratch), to come up with a time estimate for your boss.
3. Create an _examples_ folder and write the example code first, using it to define the best user experience and cleanest API you can think of for your modules. Create an example for each important permutation of your module and include enoufh documentation and reasonable defaults to make the example as easy to deploy as possible.
4. Create a _modules_ folder and implement the API you came up with as a collection of small, resuable, composable modules. Use a combination of Terraform and other tools like Docker, Packer, and Bash to omplement these modules. Make sure to pin your Terraform and provider versions.
5. Create a test folder and write automated test for each example.

## Module structure
Example module structure
```
modules
↳ examples
    ↳ alb
    ↳ asg-rolling-deploy
        ↳ one-instance
        ↳ auto-scaling
        ↳ with-load-balancer
        ↳ custom-tags
    ↳ hello-world-app
    ↳ mysql
↳ modules
    ↳ alb
    ↳ asg-rolling-deploy
    ↳ hello-world-app
    ↳ mysql
↳ tests
    ↳ alb
    ↳ asg-rolling-deploy
    ↳ hello-world-app
    ↳ mysql
```

## Terraform registry module requirements
* The module must live in a public GitHub repo.
* The repo must be named `terraform-<PROVIDER>-<NAME>` eg. `terraform-aws-rds`
* The module must follow a [specific file structure](https://www.terraform.io/docs/modules/index.html#standard-module-structure), including defining Terraform code in the root of the repo, providing a _README_ file, and using the convention of `main.tf`, `variables.tf`, and `outputs.tf` as filenames.
* The repo must use Git tags with semantic versioning (_Major.Minor.Patch_) for releases.
* See the full list in the official [hashicorp guide](https://www.terraform.io/docs/registry/modules/publish.html).

## Production-grade infrastructure checklist
|Task                |Description                                                                                                                                |Examle tools|
|--------------------|-------------------------------------------------------------------------------------------------------------------------------------------|------------|
|Install             |Install the software binaries and all dependencies.                                                                                        |Bash, Chef, Ansible, Puppet|
|Configure           |Configure the software at runtime. Includes port settings, TLS certs, service discovery, leaders, followers, replication, etc.             |Bash, Chef, Ansible, Puppet|
|Provision           |Provision the infrastructure. Includes servers, load balancers, network configuration, firewall settings, IAM permissions, etc.            |Terraform, CloudFormation|
|Deploy              |Deploy the service on top of the infrastructure. Roll out updates with no downtime. Includes blue-green, rolling, and canary deployments.  |Terraform, CloudFormation, Kubernetes, ECS|
|High availability   |Withstand outages of individual processes, servers services, data centers, and regions.                                                      |Multidatacenter, multiregion, replication, auto scaling, load balancing|
|Scalability         |Scale up and down in response to load. Scale horizontally (more servers) and/or vertically (bigger servers).                               |Auto scaling, replication, sharding, caching, divide and conquer|
|Performance         |Optimize CPU, memory, disk, network, and GPU usage. Includes query tuning, benchmarking, load testing, and profiling.                      |Dynatrace, valgrind, VisualVM, ab, Jmeter|
|Networking          |Configure static and dynamic IPs, ports, service discovery, firewalls, DNS, SSH access, and VPN access.                                    |VPCs, firewalls, routers, DNS, registrars, OpenVPN|
|Security            |Encryption in transit (TLS) and at rest (on disk), authentication, authorization, secrets management, server hardening.                    |ACM, Let's Encrypt, KMS, Cognito, Vault, CIS|
|Metrics             |Availability metrics, business metrics, app metrics, server metrics events, observability, tracing, and alerting.                          |CloudWatch, DataDog, New Relic, Honeycomb|
|Logs                |Rotate logs on disk, Aggregate log data to a central location.                                                                             |CloudWatch Logs, ELK, Sumo Logic, Papertrail|
|Backup and Restore  |Make backups of DBs, caches, and other data on a scheduled basis. Replicate to separate region/account.                                    |RDS, ElastiCache, replication|
|Cost optimization   |Pick proper Instance types, use spot and reserved Instances, use auto scaling, and nuke unused resources.                                  |Auto scaling, spot Instances, reserved Instances|
|Documentation       |Document your code, architecture, and practices. Create playbooks to respond to incidents.                                                 |README, wikis, Slack|
|Tests               |Write automated test for your infrastructure code. Run tests after every commit and nightly.                                               |Terratest, inspec, serverspec, kitchen-terraform|

## How long it takes to build production-grade infrastructure from scratch
|Type of infrastructure                      |Example                                            |Time estimate  |
|--------------------------------------------|---------------------------------------------------|---------------|
|Managed service                             |Amazon RDS                                         |1-2 weeks      |
|Self-managed distributed system (stateless) |A cluster of Node.js apps                          |2-4 weeks      |
|Self-managed distributed system (statefull) |Amazon ES                                          |2-4 months     |
|Entire architecture                         |Apps, data stores, load balancers, monitoring, etc.|6-36 months    |

## Application and infrastructure code workflows
| |Application code|Infrastructure code|
|-|----------------|-------------------|
| Use version control | <ul><li>`git clone`<li>one repo per app<li>use branches</ul> | <ul><li>`git clone`<li>_live_ and _modules_ repos<li>*don't* user branches</ul> |
| Run the code locally | <ul><li>Run on localhost<li>run tests</ul> | <ul><li>Run in a sandbox environment<li>`terraform apply`<li>`go test`</ul> |
| Make code changes | <ul><li>Change the code<li>run new code<li>run tests</ul> | <ul><li>Change the code<li>`terraform apply`<li>`go test`<li>Use test stages</ul> |
| Submit changes for review | <ul><li>Submit a pull request<li>enforce coding guidlines</ul> | <ul><li>Submit a pull request<li>Enforce coding guidlines</ul> |
| Run automated tests | <ul><li>Test run on CI server<li>Unit tests<li>Integration tests<li>End-to-end tests<li>Static analysis</ul> | <ul><li>Test run on CI server<li>Unit tests<li>Integration tests<li>End-to-end tests<li>Static analysis<li>`terraform plan`</ul> |
| Merge and release | <ul><li>`git tag`<li>Create versioned<li>immutable artifact</ul> | <ul><li>`git tag`<li>Use repo with tag as versioned<li>immutable artifact</ul> |
| Deploy | <ul><li>Deploy with terraform, orchestration tool (eg., Kubernetes, Mesos), scripts<li>Many deployment stages: rolling deployment, blue-green, canary<li>Run deployment on a CI server<li>Give CI server limited permissions<li>Promote immutable, versioned artifacts across environments</ul> | <ul><li>Deploy with terraform, atlantis, terraform enterprise terragrunt, scripts<li>Limited deployment strategies. Make sure to handle errors: retries, `errored.tfstate`!<li>Run deployment on a CI server<li>Give CI server admin permissions<li>Promote immutable, versioned artifacts across environments</ul> |

### Documentation
Good code tells the reader _what it does_, but mostly not _why it does it_.   
There are several types of documentation that you can consider and have your team members require as part of code reviews.

#### Written documentation:   
Most terraform modules should have a README that explains _what the module does_, _why it exists_, _how to use it_, and _how to modify it_.   
In fact you should **write the README first**, before any of the actual Terraform code, because that will force you to consider _what_ you're building and _why_ you're building it before you dive into the code and get lost in the details of _how_ to build it.

#### Code documentation:
Within the code itself, you should use comments as a form of documentation. Terraform treats any text that begins with a hash (#) as a comment.   
Do not use comments to explain what the code does, the code should do that itself. Only use comments to offer informations that can't be expressed in code, such as _how the code is meant to be used_ or _why_ the code uses a particular design choice.   
You also should use the `description` parameter to describe input and output variables.

#### Example code:
Every terraform module should include example code that shows how that module is meant to be used. This is a great way to highlight the intended usage patterns, give your users a way to try your module without having to write any code, and **it's the main way to add automated tests for the module**.

# Credits
Big thanks to Yevgeniy Brinkman for writing the amazing Book `Terraform: Up and Running, Second Edition by Yevgeniy Brinkman (O'Reilly.) Copyright 2019 Yevgeniy Brinkman, 978-1-492-04690-5`.   
The whole content shown in this repo is inspiered by the content and ideas mention in this book. See Yevgenity Brinkmans [GitHub](https://github.com/brikis98) and also take a look the [repo of the book](https://github.com/brikis98/terraform-up-and-running-code). Maybe you like to take a look to [his books website](https://www.terraformupandrunning.com/) and order the book at [O'REILLY](https://www.oreilly.com/library/view/terraform-up/9781492046899/).