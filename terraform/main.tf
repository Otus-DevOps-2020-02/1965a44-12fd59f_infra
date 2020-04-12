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
}

module "db" {
  source          = "./modules/db"
  public_key_path = var.public_key_path
  zone            = var.zone
  db_disk_image   = var.db_disk_image
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

##################################################################################
# RESOURCES
##################################################################################

resource "google_compute_firewall" "firewall_ssh" {
  description = "Allow SSH from anywhere"
  name = "default-allow-ssh"
  network = "default"
  priority = "65534"

  allow {
    protocol = "tcp"
    ports = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}
