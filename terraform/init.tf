terraform {
  backend "s3" {
    bucket = "open-banking-share-state"
    key    = "test_aws_full_lakehouse_example4.tfstate"
    region = "us-east-1"
  }
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~>1.6.5"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.35.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


// initialize provider at account level for provisioning workspace with AWS PrivateLink
provider "databricks" {
  alias      = "workspace"
  account_id = var.databricks_account_id

  host     = "https://reglh-private-link-ws778.cloud.databricks.com"
  username = var.databricks_account_username
  password = var.databricks_account_password
}