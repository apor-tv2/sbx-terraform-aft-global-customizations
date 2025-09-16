locals {
	ssm_parms = [
		 "/aft/account/aft-management/account-id",
		 "/aft/account/log-archive/account-id",
		 "/aft/account/ct-management/account-id",
		 "/aft/account/audit/account-id"
		 #"/aft/account/infra-shared-services/account-id"
	]
}
module "copy_ssm_parms" {
  for_each = { for idx, map in local.ssm_parms : idx => map }
  source = "./modules/copy_ssm_parameter_from_aft"
  ssm_parameter = each.value
  providers = {
    aws.vended-account = aws.vended-account
    aws.aft-management = aws.aft-management
  }
}

