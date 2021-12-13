#!/bin/sh

set -e

# ID=$(aws sts assume-role-with-web-identity --role-arn $AWS_ROLE_ARN --role-session-name mh9test --web-identity-token file://$AWS_WEB_IDENTITY_TOKEN_FILE)
# export AWS_ACCESS_KEY_ID="$(echo $ID | jq -r ".Credentials.AccessKeyId")"
# export AWS_SECRET_ACCESS_KEY="$(echo $ID | jq -r ".Credentials.SecretAccessKey")"
# export AWS_SESSION_TOKEN="$(echo $ID | jq -r ".Credentials.SessionToken")"

exec uvicorn app:app --reload --host 0.0.0.0 --port 8000