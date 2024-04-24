data "google_project" "current" {}

locals {
  sa_tf_base_name     = "sa-tf-${var.project_name}-%s"
  environments_suffix = ["dev", "prod"]
}


# Create service account for Terraform cloud workspaces
resource "google_service_account" "tf_workspaces" {
  for_each = toset(local.environments_suffix)

  account_id   = format(local.sa_tf_base_name, each.value)
  display_name = "Service Account - Terraform create-prediction ${each.value} workspace."
}


output "tf_workspaces" {
  value       = google_service_account.tf_workspaces
  sensitive   = false
  description = "Service account list to used in Terraform Cloud workspaces."
  depends_on  = [google_service_account.tf_workspaces]
}
