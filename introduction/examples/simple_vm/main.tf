# Einrichten des AWS Cloud providers 
provider "aws" {
  region = "eu-central-1"
}

# Definieren der anzulegenden Ressourcen

# Erstellen einer virtuellen Maschine.
resource "aws_instance" "server" {
  ami           = "ami-043097594a7df80ec" # Snapshot
  instance_type = "t3.micro"
}

# Ausgewählte infromationen der erstellten Ressourcen zurückgeben
output "id" {
  description = "ID"
  value       = aws_instance.server.id
}

output "private_ipv4" {
  description = "Private IPv4"
  value       = aws_instance.server.private_ip
}
