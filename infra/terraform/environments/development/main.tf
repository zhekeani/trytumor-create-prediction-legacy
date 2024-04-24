data "google_project" "current" {}

locals {
  region = "asia-southeast2"
}

module "artifact_registry" {
  source   = "./modules/artifact-registry"
  location = local.region
}

locals {
  image_name        = "fastapi-run"
  image_tag         = "v1.0.0"
  fastapi_image_url = "${module.artifact_registry.fastapi_repository_url}/${local.image_name}:${local.image_tag}"

  jwt_config_secret_name = "dev-"
}


module "cloud_run" {
  source           = "./modules/cloud-run"
  location         = local.region
  docker_image_url = local.fastapi_image_url
  jwt_config       = var.jwt_config
}

output "fastapi_cloud_run_url" {
  value       = module.cloud_run.service_url
  sensitive   = false
  description = "FastAPI Cloud Run public URL."
  depends_on  = [module.cloud_run]
}
