variable "service_account_email" {
  type        = string
  description = "Service account email."
}

variable "roles" {
  type        = list(string)
  description = "Roles to assigned to service account."
}

variable "project_id" {
  type        = string
  description = "Google Cloud project ID."
}


resource "google_project_iam_member" "multiple_roles" {
  for_each = toset(var.roles)

  project = var.project_id
  member  = "serviceAccount:${var.service_account_email}"
  role    = each.value
}