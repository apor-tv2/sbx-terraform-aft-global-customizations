data "aws_ssm_parameter" "aft_account_id" {
  provider = aws.aft-management
  name = "/aft/account/aft-management/account-id"
}

resource "aws_ssm_parameter" "aft_account_id"{
  name = "/sbxtest/aft/account/aft-management/account-id"
  type = "String"
  value = data.aws_ssm_parameter.aft_account_id
}
