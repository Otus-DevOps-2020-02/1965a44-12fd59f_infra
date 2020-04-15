##################################################################################
# VARIABLES
##################################################################################

variable project {
  description = "Project ID"
}
variable region {
  description = "Region"
  # Значение по умолчанию
  default = "europe-west1"
}

##################################################################################
# PROVIDER
##################################################################################

provider "google" {
  version = "~> 2.15"
  project = var.project
  region  = var.region
}

module "storage-bucket" {
  source   = "SweetOps/storage-bucket/google"
  version  = "0.3.1"
  project  = var.project
  location = var.region
  name     = "tfstate-core-eu"
}

output storage-bucket_url {
  value = module.storage-bucket.url
}
