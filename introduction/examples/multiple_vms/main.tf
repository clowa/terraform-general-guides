# Einrichten des AWS Cloud providers 
provider "aws" {
  region = "eu-central-1"
}

# Lokale variablen
locals {
  # Anzahl der zu erstellenden VMs
  number_vms = 2
  tags = {
    created-by = "terraform"
    owned-by   = "cahlers"
  }
}

# Definieren der anzulegenden Ressourcen

# Anlegen eines virtuellen Netzwerkes in AWS.
module "vpc" {
  source     = "../example_module_vpc" # Pfad zum Modul
  cidr_block = "172.16.1.0/24"
  tags       = local.tags
}

# Erstellen mehrer Netzwerkinterfaces für jede VM in dem erstellten virtuellen Subnetz.
resource "aws_network_interface" "nic" {
  count = local.number_vms

  subnet_id = module.vpc.subnet_id # Verweis auf das erstellte Subnetz
  tags      = local.tags
}

# Erstellen mehrerer virtuellen Maschine.
resource "aws_instance" "server" {
  count = local.number_vms

  ami           = "ami-043097594a7df80ec" # Snapshot
  instance_type = "t3.micro"
  tags          = local.tags

  primary_network_interface {
    network_interface_id = aws_network_interface.nic[count.index].id # Verweis auf erstellte  Netzwerkinterfaces
  }
}

# Verwenden eines Moduls zum Erstellen mehrerer virtuellen Maschinen.
# module "vm" {
#   count = local.number_vms

#   source      = "../example_module_vm" # Pfad zum Modul
#   instanz_typ = "t3.micro"
#   subnet_id   = module.vpc.subnet_id # Verweis auf das erstellte Subnetz
#   tags        = local.tags
# }

# Ausgewählte infromationen der erstellten ressourcen zurückgeben
output "vpc_id" {
  description = "ID des erstellten virutellen Netzwerkes"
  value       = module.vpc.vpc_id
}

output "subnet_ids" {
  description = "ID des erstellten Subnetzes des virutellen Netzwerkes"
  value       = module.vpc.subnet_id
}

output "vm_ids" {
  description = "IDs der erstellten viruellen Maschinen"
  value       = aws_instance.server[*].id
}

output "vm_private_ips_v4" {
  description = "Private IPv4 Adressen der VMs"
  value       = aws_instance.server[*].private_ip
}
