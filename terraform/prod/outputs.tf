output "app_external_ip" {
  value = module.app.app_external_ip
}
output "db_external_ip" {
  value = module.db.db_external_ip
}
output "ssh_allowed_ip" {
  value = module.vpc.ssh_allowed_ip
}
