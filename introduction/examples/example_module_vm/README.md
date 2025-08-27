<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.42 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.42 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_network_interface.nic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_instanz_typ"></a> [instanz\_typ](#input\_instanz\_typ) | (Optional) Größe der Instanz. | `string` | `"t3.micro"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID des Subnetzes in dem die Instanz erstellt werden soll. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Tags der Instanz. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | ID |
| <a name="output_private_ipv4"></a> [private\_ipv4](#output\_private\_ipv4) | Private IPv4 |
<!-- END_TF_DOCS -->