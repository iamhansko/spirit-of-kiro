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

aws bedrock-runtime invoke-model \
--model-id global.anthropic.claude-sonnet-4-5-20250929-v1:0 \
--cli-binary-format raw-in-base64-out \
--body '{"anthropic_version":"bedrock-2023-05-31", "messages":[{"role":"user","content":"explain AWS to 8th graders"}], "max_tokens":200}' tmp.json
rm tmp.json

chmod +x ./scripts/check-dependencies.sh
./scripts/check-dependencies.sh

chmod +x ./scripts/deploy-cognito.sh
./scripts/deploy-cognito.sh game-auth

docker compose down || true
docker compose build
nohup docker compose up --watch --remove-orphans --timeout 0 --force-recreate > /dev/null &
sleep 5
echo -e "${GREEN}도커 컨테이너가 실행되었습니다.${NC}"
sleep 5
docker exec server bash -c "mkdir -p /app/server/iac" &&
docker cp scripts/bootstrap-local-dynamodb.js server:/app/ &&
docker cp server/iac/dynamodb.yml server:/app/server/iac/ &&
docker exec server bash -c "bun run /app/bootstrap-local-dynamodb.js"

echo -e "${YELLOW}=============================="
echo -e "${YELLOW}Server : $(curl -s localhost:8080)"
echo -e "${YELLOW}ItemImages : $(curl -s https://d16sw0kh78rbrs.cloudfront.net)"
echo -e "${YELLOW}Client : ${GREEN}http://localhost:5173"
echo -e "${YELLOW}=============================="

# Start/Restart
# docker compose build && docker compose up --watch --remove-orphans --timeout 0 --force-recreate

# Stop
# docker compose down