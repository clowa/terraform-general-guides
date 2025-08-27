# Input variablen zur Anpassung der Ressourcen
variable "instanz_typ" {
  type        = string
  description = "(Optional) Größe der Instanz."
  default     = "t3.micro"
}

variable "subnet_id" {
  type        = string
  description = "ID des Subnetzes in dem die Instanz erstellt werden soll."
}

variable "tags" {
  type        = map(string)
  description = "(Optional) Tags der Instanz."
  default     = {}
}

# Erstellen einer virtuellen Maschine.
resource "aws_instance" "server" {
  ami           = "ami-043097594a7df80ec"
  instance_type = var.instanz_typ # Anrufen der Variable
  tags          = var.tags

  primary_network_interface {
    network_interface_id = aws_network_interface.nic.id
  }
}

resource "aws_network_interface" "nic" {
  subnet_id = var.subnet_id
  tags      = var.tags
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
