resource "google_compute_firewall" "firewall_ssh" {
  description = "Allow SSH from anywhere"
  name = "default-allow-ssh"
  network = "default"
  priority = "65534"
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  source_ranges = var.source_ranges
}
