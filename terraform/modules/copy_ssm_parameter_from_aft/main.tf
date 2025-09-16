
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
      configuration_aliases = [aws.aft-management, aws.vended-account]
    }
  }
}

data "aws_ssm_parameter" "aft_ssm_parm" {
  provider = aws.aft-management
  #name = "/aft/account/aft-management/account-id"
  #name = var.copy_ssm_parameters.ssm_source_path
  name = var.ssm_parameter
}

resource "aws_ssm_parameter" "aft_ssm_parm"{
  provider = aws.vended-account
  #name = "/aft-copy/ssm${var.copy_ssm_parameters.ssm_source_path}"
  name = "/aft-copy/ssm${var.ssm_parameter}"
  type = "String"
  value = data.aws_ssm_parameter.aft_ssm_parm.value
  overwrite = true
}
