resource "google_compute_instance" "db" {
  name         = "reddit-db"
  machine_type = "f1-micro"
  allow_stopping_for_update = true
  zone         = var.zone
  tags         = ["reddit-db"]

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

  connection {
    type  = "ssh"
    host  = self.network_interface.0.access_config.0.nat_ip
    user  = "appuser"
    agent = false
    # путь до приватного ключа
    private_key = file(var.priv_key_path)
  }
  provisioner "remote-exec" {
    inline = [
      "sudo sed -i 's/bindIp:.*$/bindIp: ${self.network_interface.0.network_ip}/;' /etc/mongod.conf",
      "sudo systemctl restart mongod"
    ]
  }

}


resource "google_compute_firewall" "firewall_mongo" {
  name    = "non-default-allow-mongodb"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }
  target_tags = ["reddit-db"]
  source_tags = ["reddit-app"]
}
