output "app_external_ip" {
  value = google_compute_instance.app[*].network_interface[0].access_config[0].nat_ip
}

#output "load_balancer_ip_address" {
#  description = "IP address of the Load Balancer"
#  value       = google_compute_forwarding_rule.fwd-rule-000.ip_address
#}
