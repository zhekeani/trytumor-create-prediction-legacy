variable "tf_org_name" {
  type        = string
  description = "Terraform Cloud organization name."
}

variable "tf_service_accounts" {
  type = object({
    dev = object({
      name  = string
      email = string
    })
    prod = object({
      name  = string
      email = string
    })
  })
  description = "Service account used by Terraform Cloud workspaces to authenticate with GCP with workload identity federation."
}
