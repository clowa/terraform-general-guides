# Input variablen zur Anpassung der Ressourcen
variable "cidr_block" {
  type        = string
  description = "(Optional) CIDR Block des VPC."
}

variable "tags" {
  type        = map(string)
  description = "(Optional) Tags der Instanz."
  default     = {}
}

# Erstellen eines Virtuellen Netzwerks mit Subnetz.
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  tags       = var.tags
}

resource "aws_subnet" "this" {
  vpc_id     = aws_vpc.this.id # Verweis auf erstelltes Netzwerk
  cidr_block = var.cidr_block  # Verweis auf Variable
  tags       = var.tags
}

# Ausgewählte Informationen der erstellten Ressourcen zurückgeben
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "subnet_id" {
  description = "ID of the Subnet"
  value       = aws_subnet.this.id
}
