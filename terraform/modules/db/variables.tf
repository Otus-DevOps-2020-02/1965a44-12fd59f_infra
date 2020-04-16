variable public_key_path {
  description = "Path to the public key used to connect to instance"
}
variable "priv_key_path" {
  description = "Path to the secret key used by provisioner"
}
variable zone {
  description = "Zone"
}
variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "mongodb-base"
}
