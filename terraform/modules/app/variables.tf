variable public_key_path {
  description = "Path to the public key used to connect to instance"
}
variable "priv_key_path" {
  description = "Path to the secret key used by provisioner"
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
  # Значение по умолчанию
  default = "1"
}
variable source_ranges {
  description = "Allowed IP addresses"
  default     = ["0.0.0.0/0"]
}
variable "db_ipaddr" {
}
