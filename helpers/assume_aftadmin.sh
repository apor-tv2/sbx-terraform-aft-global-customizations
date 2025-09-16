#! /bin/bash
# Version: 1.1 2022-06-24 Unsetting AWS_PROFILE since, when set, it interferes with script operation
#          1.0 2022-02-02 Initial Version
#
# Purpose: For use with AFT: This script runs the local copy of TF code as if it were running within AFT pipeline.
#        * Facilitates testing of what the AFT pipline will do 
#           * Provides the ability to run terraform with custom arguments (like 'plan' or 'move') which are currently not supported within the pipeline.
#
# © 2021 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement between
# Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.
#
# Note: Arguments to this script are passed directly to 'terraform' without parsing nor validation by this script.
#
# Prerequisites:
#    1. local copy of ct GIT repositories
#    2. local backend.tf and aft-providers.tf filled with data for the target account on which terraform is to be run
#       Hint: The contents of above files can be obtain from the logs of a previous execution of the AFT pipeline for the target account.
#    3. 'terraform' binary is available in local PATH
#    4. Recommended: .gitignore file containing 'backend.tf', 'aft_providers.tf' so the local copy of these files are not pushed back to git

readonly credentials=$(aws sts assume-role \
    --role-arn arn:aws:iam::$(aws sts get-caller-identity --query "Account" --output text ):role/AWSAFTAdmin \
    --role-session-name AWSAFT-Session \
    --query Credentials )

STORED_AWS_PROFILE=$AWS_PROFILE
STORED_AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
STORED_AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
STORED_AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN

unset AWS_PROFILE
export AWS_ACCESS_KEY_ID=$(echo $credentials | jq -r '.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $credentials | jq -r '.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $credentials | jq -r '.SessionToken')
terraform "$@"

set AWS_PROFILE=$STORED_AWS_PROFILE
set AWS_ACCESS_KEY_ID=$STORED_AWS_ACCESS_KEY_ID
set AWS_SECRET_ACCESS_KEY=$STORED_AWS_SECRET_ACCESS_KEY
set AWS_SESSION_TOKEN=$STORED_AWS_SESSION_TOKEN
