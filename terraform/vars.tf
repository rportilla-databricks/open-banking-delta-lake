variable "databricks_account_id" {}

variable "databricks_workspace_url" {
}
variable "databricks_account_username" {
}

variable "databricks_account_password" {
}

variable "open_banking_delta_table_bucket" {
}

variable "aws_account_id" {

}

locals {
  prefix = "fsi-ob"
}

locals {
  tags = {  }
}
