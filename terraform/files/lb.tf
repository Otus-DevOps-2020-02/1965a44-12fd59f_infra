# ------------------------------------------------------------------------------
# CREATE FORWARDING RULE ANd ADDRESS???
# ------------------------------------------------------------------------------
resource "google_compute_forwarding_rule" "fwd-rule-000" {
  name       = "fwd-rule-000"
  target     = google_compute_target_pool.nlb-pool-000.self_link
  port_range = "9292"
}
# ------------------------------------------------------------------------------
# CREATE HEALTH CHECK
# ------------------------------------------------------------------------------
resource "google_compute_http_health_check" "hlth-chck-000" {
  name = "hlth-chck-000"
  port = "9292"
}
# ------------------------------------------------------------------------------
# CREATE TARGET POOL
# ------------------------------------------------------------------------------
resource "google_compute_target_pool" "nlb-pool-000" {
  name = "nlb-pool-000"

  instances = [
    for app in google_compute_instance.app : app.self_link
  ]

  health_checks = [
    google_compute_http_health_check.hlth-chck-000.name,
  ]
}
