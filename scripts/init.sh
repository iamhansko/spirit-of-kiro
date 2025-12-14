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

# Invoke Bedrock Model
# aws bedrock-runtime invoke-model \
# --model-id global.anthropic.claude-sonnet-4-5-20250929-v1:0 \
# --cli-binary-format raw-in-base64-out \
# --body '{"anthropic_version":"bedrock-2023-05-31", "messages":[{"role":"user","content":"explain AWS to 8th graders"}], "max_tokens":200}' tmp.json
# rm tmp.json

chmod +x ./scripts/check-dependencies.sh
./scripts/check-dependencies.sh

# Detect container runtime
if command -v docker &> /dev/null; then
    CONTAINER_CMD="docker"
elif command -v finch &> /dev/null; then
    CONTAINER_CMD="finch"
else
    echo -e "${RED}오류: Docker 또는 Finch가 설치되어 있지 않습니다.${NC}"
    exit 1
fi

echo -e "${GREEN}컨테이너 런타임: $CONTAINER_CMD${NC}"

chmod +x ./scripts/deploy-cognito.sh
./scripts/deploy-cognito.sh game-auth

$CONTAINER_CMD compose down || true

if [ "$CONTAINER_CMD" = "docker" ]; then
    nohup $CONTAINER_CMD compose up --watch --remove-orphans --timeout 0 --force-recreate > /dev/null &
else
    $CONTAINER_CMD compose up -d --force-recreate
fi

echo -e "${YELLOW}도커 컨테이너가 준비될 때까지 대기 중입니다...${NC}"
until $CONTAINER_CMD exec server bash -c "echo 'Healthy'" &> /dev/null; do
  sleep 5
done
echo -e "${GREEN}도커 컨테이너가 실행되었습니다${NC}"
sleep 5
$CONTAINER_CMD exec server bash -c "mkdir -p /app/server/iac" &&
$CONTAINER_CMD cp scripts/bootstrap-local-dynamodb.js server:/app/ &&
$CONTAINER_CMD cp server/iac/dynamodb.yml server:/app/server/iac/ &&
$CONTAINER_CMD exec server bash -c "bun run /app/bootstrap-local-dynamodb.js"

echo -e "${YELLOW}=============================="
echo -e "${YELLOW}Server : $(curl -s localhost:8080)"
echo -e "${YELLOW}ItemImages : $(curl -s https://d16sw0kh78rbrs.cloudfront.net)"
echo -e "${YELLOW}Client : ${GREEN}http://localhost:5173"
echo -e "${YELLOW}=============================="

# Start/Restart
# docker compose build && docker compose up --watch --remove-orphans --timeout 0 --force-recreate

# Stop
# docker compose down