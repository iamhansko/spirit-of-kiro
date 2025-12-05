#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

if ! (aws sts get-caller-identity --query 'Arn' &> /dev/null); then
  echo -e "${RED}오류 : AWS CLI Credentials 설정이 필요합니다."
  exit 1
else
  echo -e "${GREEN}$(aws sts get-caller-identity --query 'Arn' --output text | cut -d'/' -f2-) 권한으로 작업을 시작합니다."
fi

docker compose down
docker image rm amazon/dynamodb-local
docker image rm amazon/amazon-ecs-local-container-endpoints
docker image rm spirit-of-kiro-server
docker image rm spirit-of-kiro-client

export REGION=us-east-1
export COGNITO_STACK_NAME=game-auth
aws cloudformation delete-stack --stack-name $COGNITO_STACK_NAME-cognito --region $REGION
aws cloudformation wait stack-delete-complete --stack-name $COGNITO_STACK_NAME-cognito --region $REGION

export IDENTITY_STORE_ID=$(aws sso-admin list-instances --query 'Instances[0].IdentityStoreId' --region $REGION | sed -e 's/^"//' -e 's/"$//')

if [ -z "$IDENTITY_STORE_ID" ] || [ "$IDENTITY_STORE_ID" == "None" ]; then
  echo -e "${YELLOW}IAM Identity Center가 설정되지 않았습니다. 건너뜁니다.${NC}"
else
  echo -e "${GREEN}Identity Store ID: $IDENTITY_STORE_ID${NC}"
  USER_IDS=$(aws identitystore list-users --identity-store-id $IDENTITY_STORE_ID --query 'Users[].UserId' --output text)
  
  if [ -z "$USER_IDS" ]; then
    echo -e "${YELLOW}삭제할 사용자가 없습니다.${NC}"
  else
    echo -e "${GREEN}다음 사용자들을 삭제합니다:${NC}"
    aws identitystore list-users --identity-store-id $IDENTITY_STORE_ID --query 'Users[].[UserName,UserId]' --output table
    
    for USER_ID in $USER_IDS; do
      aws identitystore delete-user --identity-store-id $IDENTITY_STORE_ID --user-id $USER_ID
      if [ $? -eq 0 ]; then
        echo -e "${GREEN}사용자 삭제 완료: $USER_ID${NC}"
      else
        echo -e "${RED}사용자 삭제 실패: $USER_ID${NC}"
      fi
    done
  fi
fi

rm -rf docker