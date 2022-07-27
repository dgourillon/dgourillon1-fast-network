data "terraform_remote_state" "bootstrap" {
  backend = "remote"
  config = {
    organization = "dgourillon1"
    workspaces = {
      name = "dgourillon1-fast-boootstrap"
    }
  }
}


data "terraform_remote_state" "resman" {
  backend = "remote"
  config = {
    organization = "dgourillon1"
    workspaces = {
      name = "dgourillon1-fast-resman"
    }
  }
}

locals {
  # Common tags to be assigned to all resources
  organization = data.terraform_remote_state.bootstrap.outputs.organization
  automation   = data.terraform_remote_state.bootstrap.outputs.automation
  billing_account   = data.terraform_remote_state.bootstrap.outputs.billing_account
  service_accounts  = data.terraform_remote_state.resman.outputs.service_accounts
  folder_ids  = data.terraform_remote_state.resman.outputs.folder_ids
}



