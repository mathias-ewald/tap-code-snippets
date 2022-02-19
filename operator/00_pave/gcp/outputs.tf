output "jumphost_name" {
  value = module.jumphost.hostname
}

output "jumphost_zone" {
  value = var.zones[0]
}