data "google_project" "current" {}

locals {
  dev_workspace_id  = "ws-vAekCJyK2ySeo1x3"
  prod_workspace_id = "ws-zsHoRQZ3gD6rWV5H"
}

locals {
  workspaces = {
    development = {
      svc_roles = [
        "roles/serviceusage.serviceUsageAdmin",
        "roles/iam.serviceAccountAdmin",
        "roles/iam.serviceAccountKeyAdmin",
        "roles/iam.serviceAccountUser",
        "roles/iam.workloadIdentityPoolAdmin",
        "roles/secretmanager.admin",
        "roles/run.admin"
      ]
      environment_type = "development"
      service_account  = var.tf_service_accounts["dev"]
      workspace_id     = local.dev_workspace_id
    }
    production = {
      svc_roles = [
        "roles/serviceusage.serviceUsageAdmin",
        "roles/iam.serviceAccountAdmin",
        "roles/iam.serviceAccountKeyAdmin",
        "roles/iam.serviceAccountUser",
        "roles/iam.workloadIdentityPoolAdmin",
        "roles/secretmanager.admin",
        "roles/run.admin"
      ]
      environment_type = "production"
      service_account  = var.tf_service_accounts["prod"]
      workspace_id     = local.prod_workspace_id
    }
  }
}

module "project_iam_member" {
  for_each = local.workspaces

  source                = "../../project-iam-member"
  project_id            = data.google_project.current.project_id
  service_account_email = each.value.service_account.email
  roles                 = each.value.svc_roles
}