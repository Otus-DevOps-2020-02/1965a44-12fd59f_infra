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
  # Значение по умолчанию
  default = "1"
}
