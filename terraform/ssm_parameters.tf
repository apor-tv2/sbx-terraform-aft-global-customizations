
output "which_accountid_aft_management"{
	value = data.aws_caller_identity.which_accountid_aft_management
}
data "aws_caller_identity" "which_accountid_aft_management"{
  provider = aws.aft-management
}
output "which_accountid_default"{
	value = data.aws_caller_identity.which_accountid_default
}
data "aws_caller_identity" "which_accountid_default"{
}
output "which_accountid_eucentral1"{
	value = data.aws_caller_identity.which_accountid_eucentral1
}
data "aws_caller_identity" "which_accountid_eucentral1"{
  provider = aws.eu-central-1
}

data "aws_ssm_parameter" "aft_account_id" {
  provider = aws.aft-management
  name = "/aft/account/aft-management/account-id"
}

resource "aws_ssm_parameter" "aft_account_id"{
  provider = aws.eu-central-1
  name = "/sbxtest/aft/account/aft-management/account-id"
  type = "String"
  value = data.aws_ssm_parameter.aft_account_id.value
}
