# Einrichten des AWS Cloud providers 
provider "aws" {
  region  = "eu-central-1"
  profile = "default"
}

# Locale variablen
locals {
  # Anzahl der zu erstellenden VMs
  number_vms = 2
}

# Definieren der anzulegenden Ressourcen

# Anlegen eines virtuellen Netzwerkes in AWS.
resource "aws_vpc" "network" {
  cidr_block = "172.16.0.0/16"
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.network.id # Verweis auf erstelltes Netzwerk
  cidr_block        = "172.16.1.0/24"
  availability_zone = "eu-central-1a"
}

# Erstellen mehrerer virtuellen Maschiene.
resource "aws_instance" "server" {
  count         = local.number_vms
  ami           = "ami-043097594a7df80ec" # Snapshot
  instance_type = "t3.micro"

  network_interface {
    network_interface_id = aws_network_interface.nic[count.index].id # Verweis auf erstellte  Netzwerkinterfaces
    device_index         = 0
  }
}

# Erstellen mehrer Netzwerkinterfaces für jede VM in dem erstellten virtuellen Subnetz.
resource "aws_network_interface" "nic" {
  count     = local.number_vms
  subnet_id = aws_subnet.subnet.id # Verweis auf erstelltes Subnetz
}

# Ausgewählte infromationen der erstellten ressourcen zurückgeben
output "vpc_id" {
  description = "ID des erstellten virutellen Netzwerkes"
  value       = aws_vpc.network.id
}

output "subnet_ids" {
  description = "ID des erstellten Subnetzes des virutellen Netzwerkes"
  value       = aws_subnet.subnet.id
}

output "vm_ids" {
  description = "IDs der erstellten viruellen Maschinen"
  value       = aws_instance.server[*].id
}

output "vm_private_ips_v4" {
  description = "Private IPv4 Adressen der VMs"
  value       = aws_instance.server[*].private_ip
}