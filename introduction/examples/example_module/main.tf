# Einrichten des AWS Cloud providers 
provider "aws" {
  region  = "eu-central-1"
  profile = "default"
}

# Input variablen zur Anpassung der Ressourcen
variable "instanz_typ" {
  type        = string
  description = "(Optional) Größe der Instanz."
  default     = "t3.micro"
}

# Erstellen einer virtuellen Maschine.
resource "aws_instance" "server" {
  ami           = "ami-043097594a7df80ec"
  instance_type = var.instanz_typ # Anrufen der Variable
}

# Ausgewählte Informationen der erstellten Ressourcen zurückgeben
output "id" {
  description = "ID"
  value       = aws_instance.server.id
}

output "private_ipv4" {
  description = "Private IPv4"
  value       = aws_instance.server.private_ip
}