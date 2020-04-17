terraform {
  # Версия terraform
  required_version = "~> 0.12.8"
}

##################################################################################
# VARIABLES
##################################################################################

variable project {
  description = "Project ID"
}
variable region {
  description = "Region"
  default     = "europe-west1"
}
variable zone {
  description = "Zone"
  default     = "europe-west1-d"
}
variable public_key_path {
  description = "Path to the public key used to connect to instance"
}
variable "private_key_path" {
  description = "Path to the secret key used by provisioner"
}
variable app_disk_image {
  description = "Base disk image for reddit-app"
}
variable db_disk_image {
  description = "Base disk image for mongodb"
}
variable "allowed_ip" {
  type = list(string)
}

##################################################################################
# DATA
##################################################################################

data "google_compute_instance" "db" {
  name       = "reddit-db"
  zone       = var.zone
  depends_on = [module.db]
}

##################################################################################
# MODULES
##################################################################################

module "app" {
  source          = "../modules/app"
  public_key_path = var.public_key_path
  priv_key_path   = var.private_key_path
  zone            = var.zone
  app_disk_image  = var.app_disk_image
  db_ipaddr       = data.google_compute_instance.db.network_interface.0.network_ip
  source_ranges   = var.allowed_ip
  instance_count  = 1
}

module "db" {
  source          = "../modules/db"
  public_key_path = var.public_key_path
  priv_key_path   = var.private_key_path
  zone            = var.zone
  db_disk_image   = var.db_disk_image
}

module "vpc" {
  source        = "../modules/vpc"
  source_ranges = var.allowed_ip
}

##################################################################################
# PROVIDERS
##################################################################################

provider "google" {
  # Версия провайдера
  version = "~> 2.5"
  # ID проекта
  project = var.project
  region  = var.region
}
