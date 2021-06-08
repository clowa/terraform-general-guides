module "vm" {
  source      = "../example_module" # Als quelle können auch repositories und registries verwendet werden.
  instanz_typ = "t2.nano"
}

# Modulausgaben ausgeben

output "vm_id" {
  description = "ID der VM"
  value       = module.vm.id
}