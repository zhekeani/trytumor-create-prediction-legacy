output "fastapi_repo_url" {
  value       = module.artifact_registry.fastapi_repository_url
  sensitive   = false
  description = "FastAPI Artifact Registry repository URL."
  depends_on  = [module.artifact_registry]
}

output "fastapi_image_url" {
  value       = local.fastapi_image_url
  sensitive   = false
  description = "FastAPI Artifact Registry docker image url."
}

