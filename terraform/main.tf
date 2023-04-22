data "aws_s3_bucket" "external" {
  bucket = "lakehouse-delta"
  provider = aws
}

data "aws_iam_policy_document" "passrole_for_uc" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["arn:aws:iam::414351767826:role/unity-catalog-prod-UCMasterRole-14S5ZJVKOTYTL"]
      type        = "AWS"
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.databricks_account_id]
    }
  }
  statement {
    sid     = "ExplicitSelfRoleAssumption"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:PrincipalArn"
      values   = ["arn:aws:iam::${var.aws_account_id}:role/${local.prefix}-uc-access"]
    }
  }
}

resource "aws_iam_policy" "external_data_access" {
  // Terraform's "jsonencode" function converts a
  // Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "${data.aws_s3_bucket.external.id}-access"
    Statement = [
      {
        "Action" : [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ],
        "Resource" : [
          data.aws_s3_bucket.external.arn,
          "${data.aws_s3_bucket.external.arn}/*"
        ],
        "Effect" : "Allow"
      }
    ]
  })
  tags = merge(local.tags, {
    Name = "${local.prefix}-unity-catalog external access IAM policy"
  })
}

resource "aws_iam_role" "external_data_access" {
  name                = "${local.prefix}-external-access"
  assume_role_policy  = data.aws_iam_policy_document.passrole_for_uc.json
  managed_policy_arns = [aws_iam_policy.external_data_access.arn]
  tags = merge(local.tags, {
    Name = "${local.prefix}-unity-catalog external access IAM role"
  })
}

resource "databricks_storage_credential" "external" {
  name = aws_iam_role.external_data_access.name
  aws_iam_role {
    role_arn = aws_iam_role.external_data_access.arn
  }
  comment = "Managed by TF"
  provider = databricks.workspace
  depends_on = [aws_iam_role.external_data_access]
}

resource "databricks_external_location" "some" {
  name            = "external"
  url             = "s3://${data.aws_s3_bucket.external.id}/api_txns15"
  credential_name = databricks_storage_credential.external.id
  comment         = "Managed by TF"
    depends_on = [databricks_storage_credential.external]
  provider = databricks.workspace

}

resource "databricks_share" "some" {
  name = "open_banking_share"
  provider = databricks.workspace
  object {
    name                        = "sandbox.things.open_banking_api_txns"
    data_object_type            = "TABLE"
  }

}

resource "random_password" "db2opensharecode" {
  length  = 16
  special = true
}


resource "databricks_recipient" "db2open" {
  name = "open_banking_recipient"
  authentication_type = "TOKEN"
  sharing_code        = random_password.db2opensharecode.result
  provider = databricks.workspace

}

resource "databricks_grants" "some" {
  share = databricks_share.some.name
  grant {
    principal  = databricks_recipient.db2open.name
    privileges = ["SELECT"]
  }
    provider = databricks.workspace

}