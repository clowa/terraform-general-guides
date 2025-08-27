module "vpc" {
  source     = "../example_module_vpc" # Als quelle können auch repositories und registries verwendet werden.
  cidr_block = "172.16.1.0/24"
}


module "vm" {
  source      = "../example_module_vm" # Als quelle können auch repositories und registries verwendet werden.
  instanz_typ = "t2.nano"
  subnet_id   = module.vpc.subnet_id
}

# Modulausgaben ausgeben

output "vm_id" {
  description = "ID der VM"
  value       = module.vm.id
}
