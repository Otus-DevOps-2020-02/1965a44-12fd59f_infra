terraform {
  backend "gcs" {
    bucket = "tfstate-core-eu"
    prefix = "shared"
  }
}

# Retrieves state data from a Terraform backend. This allows you to use the root-level outputs of one or more Terraform configurations as input data for another configuration.
data "terraform_remote_state" "default" {
  backend = "gcs"
  config = {
    bucket = "tfstate-core-eu"
    prefix = "shared"
  }
}
