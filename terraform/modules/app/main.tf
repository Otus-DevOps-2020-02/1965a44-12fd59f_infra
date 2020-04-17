resource "google_compute_instance" "app" {
  name         = "reddit-app${count.index}"
  machine_type = "f1-micro"
  allow_stopping_for_update = true
  zone         = var.zone
  count        = var.instance_count
  tags         = ["reddit-app"]

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = var.app_disk_image
    }
  }

  scheduling {
    automatic_restart = false
    preemptible       = true
  }

  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"
    # использовать ephemeral IP для доступа из Интернет
    access_config {
      nat_ip = google_compute_address.app_ip.address
    }
  }

  metadata = {
    # путь до публичного ключа
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  connection {
    type  = "ssh"
    host  = google_compute_address.app_ip.address
    user  = "appuser"
    agent = false
    # путь до приватного ключа
    private_key = file(var.priv_key_path)
  }


  provisioner "file" {
    content     = templatefile("${path.module}/files/puma.service.tmpl", { db_ipaddr = var.db_ipaddr })
    destination = "/tmp/puma.service"
  }
  provisioner "remote-exec" {
    script = "${path.module}/files/deploy.sh"
  }
}

resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}

resource "google_compute_firewall" "firewall_puma" {
  name = "non-default-allow-reddit"
  # Название сети, в которой действует правило
  network = "default"
  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }
  # Каким адресам разрешаем доступ
  source_ranges = var.source_ranges
  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["reddit-app"]
}
