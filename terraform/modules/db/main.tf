resource "google_compute_instance" "db" {
  name = "reddit-db"
  machine_type = "g1-small"
  zone = var.zone
  tags = ["reddit-db"]

  boot_disk {
      initialize_params {
      image = var.db_disk_image
      }
  }

  scheduling {
    automatic_restart = false
    preemptible       = true
  }

  network_interface {
    network = "default"
    access_config {}
  }
  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
 }

 resource "google_compute_firewall" "firewall_mongo" {
  name = "non-default-allow-mongodb"
  network = "default"
  allow {
    protocol = "tcp"
    ports = ["27017"]
  }
  target_tags = ["reddit-db"]
  source_tags = ["reddit-app"]
}
