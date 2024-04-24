data "google_project" "current" {}

locals {
  project_name = "trytumor-cp"
  tf_org_name  = "zhekeani-first-org"
}

module "service_account" {
  source       = "./modules/service-account"
  tf_org_name  = local.tf_org_name
  project_name = local.project_name
}

output "sa_tf_workspaces" {
  value = {
    for environment, service_account in module.service_account.tf_workspaces :
    environment => {
      name  = service_account.name
      email = service_account.email
    }
  }

  sensitive   = false
  description = "Terraform workspaces service account."
  depends_on  = [module.service_account]
}

module "terraform_cloud" {
  source      = "./modules/environments/terraform-cloud"
  tf_org_name = local.tf_org_name
  tf_service_accounts = {
    for environment, service_account in module.service_account.tf_workspaces :
    environment => {
      name  = service_account.name
      email = service_account.email
    }
  }
}
