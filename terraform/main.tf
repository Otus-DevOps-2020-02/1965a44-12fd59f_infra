terraform {
  # Версия terraform
  required_version = "~> 0.12.8"
}

##################################################################################
# VARIABLES
##################################################################################

variable instance_count {
  description = "A number of instances we want"
  # Значение по умолчанию
  default = "1"
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
