variable public_key_path {
  description = "Path to the public key used to connect to instance"
}
variable zone {
  description = "Zone"
}
variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "app-base"
}
variable instance_count {
  description = "A number of instances we want"
}
variable source_ranges {
  description = "Allowed IP addresses"
  default     = ["0.0.0.0/0"]
}
variable "app_instance_name" {
  description = "Name of app instances"
}
variable "auto_restart" {
  description = "Scheduling strategy for auto restart depends on preempt (boolean)"
}
variable "preempt" {
  description = "When you leave it in the active state a system can be powered off by GCP itself. (boolean)"
}
