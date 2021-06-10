# Recommended practices

- Enforce formatting by `terraform fmt`
- Create docs by `terraform-docs` eg. `terraform-docs markdown . --output-file README.md`

## Develop IaC as single engineer

1. Write IaC
2. Enforce formatting (`terraform fmt`)
3. Validate IaC (`terraform init`, `terraform plan`)
4. Deploy IaC (`terraform apply`)
5. Do everything again

## Develop IaC within a Team

1. Write IaC
2. Enforce formatting (`terraform fmt`)
3. Validate IaC (`terraform init`, `terraform plan`)
4. Commit to VCS - single source of truth. (`git commit -m "I changed something"`)
5. Deploy from VCS. Run `terraform apply` by pipeline.
6. Do everything again

## Develop IaC with multiple Teams

1. Hierarchy decompose IaC into workspaces for each layer.
   1. Underlying cloud configuration (Network, Access Control)
   2. Middleware tier (Monitoring, Logging, Security)
2. Consume shared tiers within your application tier.
3. Limit access to different tiers / workspaces via RBAC. Everybody should be able to see what a workspace does, but just the team members should be able to change something within this workspace.

## Using IaC with an organization

Within an organization not everyone is terraform enabled and not everyone needs to be that.

1. Separate publishers and consumers
   1. Publishers develop modules to define standards how to do stuff and share them with a registry. How to deploy a Java or an Go app.
   2. Consumers using defined modules to deploy stuff, eg. apps.
2. Define a Sandbox and define security as code with `Sentinel`
   1. Define where production is deployed to.
   2. Reject IaC that violates the policies.
