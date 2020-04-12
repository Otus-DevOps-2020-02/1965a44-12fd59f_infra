terraform {
  # Версия terraform
  required_version = "~> 0.12.8"
}

##################################################################################
# MODULES
##################################################################################

module "app" {
  source          = "./modules/app"
  public_key_path = var.public_key_path
  zone            = var.zone
  app_disk_image  = var.app_disk_image
  source_ranges = ["93.123.189.16/32"]
}

module "db" {
  source          = "./modules/db"
  public_key_path = var.public_key_path
  zone            = var.zone
  db_disk_image   = var.db_disk_image
}

module "vpc" {
  source = "./modules/vpc"
  source_ranges = ["93.123.189.16/32"]
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
