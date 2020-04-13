variable public_key_path {
  description = "Path to the public key used to connect to instance"
}
variable zone {
  description = "Zone"
}
variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "mongodb-base"
}
variable "db_instance_name" {
  description = "Name of db instances"
}
variable "auto_restart" {
  description = "Scheduling strategy for auto restart depends on preempt (boolean)"
}
variable "preempt" {
  description = "When you leave it in the active state a system can be powered off by GCP itself. (boolean)"
}
