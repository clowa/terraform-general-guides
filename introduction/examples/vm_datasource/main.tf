# Einrichten des AWS Cloud providers 
provider "aws" {
  region = "eu-central-1"
}

# Abrufen von Daten von AWS

# Abrufen der Informationen des virutellen Netzwerkes
data "aws_vpc" "network" {
  id = "vpc-0c7ec20e383d6470e" # ID des zu verwendenden VPC
}

# Abrufen der Subnetze des virtullen Netzwerkes
data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.network.id]
  }
}

# Definieren der anzulegenden Ressourcen

# Erstellen einer virtuellen Maschine.
resource "aws_instance" "server" {
  ami           = "ami-043097594a7df80ec" # Snapshot
  instance_type = "t3.micro"

  primary_network_interface {
    network_interface_id = aws_network_interface.nic.id # Verweis auf erstellte  Netzwerkinterface
  }
}

# Erstellen eines Netzwerkinterfaces für die VM in dem ersten abgerufenen virtuellen Subnetz.
resource "aws_network_interface" "nic" {
  subnet_id = sort(data.aws_subnets.subnets.ids)[0] # Verweis auf das erste abgerufenden Subnetz
}

# Ausgewählte infromationen der erstellten ressourcen zurückgeben
output "vpc_id" {
  description = "ID des abgerufenen virutellen Netzwerkes"
  value       = data.aws_vpc.network.id
}

output "subnet_ids" {
  description = "IDs der abgerufenen Subnetze des virutellen Netzwerkes"
  value       = data.aws_subnets.subnets.id
}

output "vm_id" {
  description = "IDs der erstellten viruellen Maschinen"
  value       = aws_instance.server.id
}

output "vm_private_ip_v4" {
  description = "Private IPv4 Adressen der VMs"
  value       = aws_instance.server.private_ip
}
