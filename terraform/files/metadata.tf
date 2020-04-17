resource "google_compute_project_metadata_item" "default" {
  key   = "ssh-keys"
  value = "appuser1:${file(var.public_key_path)}"
}

#resource "google_compute_project_metadata_item" "multiple-users" {
#  key   = "ssh-keys"
#  value = "appuser1:${file(var.public_key_path)} \nappuser2:${file(var.public_key_path)} \nappuser3:${file(var.public_key_path)}"
#}
