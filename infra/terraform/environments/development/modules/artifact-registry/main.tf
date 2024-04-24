data "google_project" "current" {}

# Enable the APIs
module "project-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 14.5"

  project_id                  = data.google_project.current.project_id
  enable_apis                 = true
  disable_services_on_destroy = false

  activate_apis = [
    "artifactregistry.googleapis.com",
  ]
}

locals {
  repo_name = "${data.google_project.current.name}-fastapi-run"
}


# FastAPI create-prediction repository
resource "google_artifact_registry_repository" "fastapi_repo" {

  location      = var.location
  repository_id = local.repo_name
  description   = "${local.repo_name} docker repository"
  format        = "DOCKER"
  depends_on    = [module.project-services]
}

output "fastapi_repository_url" {
  value       = "${var.location}-docker.pkg.dev/${data.google_project.current.project_id}/${local.repo_name}"
  sensitive   = false
  description = "FastAPI Artifact Registry repository URL."
}
