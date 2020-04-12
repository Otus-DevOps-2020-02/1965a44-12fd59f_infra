variable project {
  description = "Project ID"
}
variable region {
  description = "Region"
  # Значение по умолчанию
  default = "europe-west1"
}
variable "zone" {
  description = "Zone"
  default     = "europe-west1-d"
}
variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable disk_image {
  description = "Disk image"
}
variable app_disk_image {
  description = "Base disk image for reddit-app"
}
variable db_disk_image {
  description = "Base disk image for mongodb"
}
variable "private_key_path" {
  description = "Path to the secret key used for ssh access"
}
