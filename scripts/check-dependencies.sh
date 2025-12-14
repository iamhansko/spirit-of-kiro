#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "Checking dependencies..."

# Function to print instructions
print_instructions() {
    echo -e "\n${YELLOW}How to fix:${NC}"
    echo -e "$1"
}

if command -v docker &> /dev/null; then
    echo -e "${GREEN}✓ Docker is installed${NC}"
    docker_version=$(docker --version)
    echo "  Version: $docker_version"
    CONTAINER_CMD="docker"
elif command -v finch &> /dev/null; then
    echo -e "${GREEN}✓ Finch is installed${NC}"
    finch_version=$(finch --version)
    echo "  Version: $finch_version"
    CONTAINER_CMD="finch"
else
    echo -e "${RED}✗ No container runtime (Docker or Finch) is installed${NC}"
    print_instructions "A. Install Docker Desktop:
   - Visit https://www.docker.com/products/docker-desktop
   - Download and install for your operating system
   - Start Docker Desktop after installation

OR

B. Install Finch:
    - Visit https://github.com/runfinch/finch
    - Download and install for your operating system"
    
    exit 1
fi

# Check AWS credentials
if ! command -v aws &> /dev/null; then
    echo -e "${RED}✗ AWS CLI is not installed${NC}"
    print_instructions "1. Install AWS CLI:
   - macOS: brew install awscli
   - Linux: pip install awscli
   - Windows: Download the MSI installer from AWS website

2. Verify installation:
   aws --version"
    exit 1
fi

echo -e "${GREEN}✓ AWS CLI is installed${NC}"

# Check AWS credentials
if ! aws sts get-caller-identity &> /dev/null; then
    echo -e "${RED}✗ AWS credentials are not configured or invalid${NC}"
    print_instructions "1. Configure AWS credentials:
   aws configure

2. Enter your credentials when prompted:
   - AWS Access Key ID
   - AWS Secret Access Key
   - Default region (e.g., us-east-1)
   - Default output format (json)

3. If you don't have credentials:
   - Log into AWS Console
   - Go to IAM → Users → Your User
   - Create new access key
   - Save the Access Key ID and Secret Access Key"
    exit 1
fi

echo -e "${GREEN}✓ AWS credentials are valid${NC}"

# Check AWS Bedrock access
echo "Checking AWS Bedrock model access..."

# List of required models
required_models=(
    "amazon.nova-pro"
    "anthropic.claude-3-sonnet-20240229"
    "anthropic.claude-3-sonnet-20240229-v1:0"
)

# List of optional models (for image generation)
optional_models=(
    "amazon.titan-embed-text-v2:0"
    "amazon.nova-canvas"
)

# Get available models
available_models=$(aws bedrock list-foundation-models --query "modelSummaries[*].modelId" --output text)

# Check required models
echo -e "\nChecking required models:"
all_required_models_available=true
missing_required_models=()
for model in "${required_models[@]}"; do
    if echo "$available_models" | grep -q "$model"; then
        echo -e "${GREEN}✓ Access to $model is available${NC}"
    else
        echo -e "${RED}✗ No access to $model${NC}"
        all_required_models_available=false
        missing_required_models+=("$model")
    fi
done

if [ "$all_required_models_available" = false ]; then
    echo -e "${RED}Some required AWS Bedrock models are not accessible${NC}"
    print_instructions "1. Enable AWS Bedrock access:
   - Log into AWS Console
   - Navigate to Amazon Bedrock
   - Request access to the following models:
     ${missing_required_models[*]}

2. Wait for model access approval (usually takes <24 hours)

3. Verify access:
   aws bedrock list-foundation-models"
    exit 1
fi

# Check optional models
echo -e "\nChecking optional models (for image generation):"
missing_optional_models=()
for model in "${optional_models[@]}"; do
    if echo "$available_models" | grep -q "$model"; then
        echo -e "${GREEN}✓ Access to $model is available${NC}"
    else
        echo -e "${YELLOW}⚠ No access to $model (optional)${NC}"
        missing_optional_models+=("$model")
    fi
done

if [ ${#missing_optional_models[@]} -gt 0 ]; then
    echo -e "\n${YELLOW}Note: The following optional models are not available:${NC}"
    for model in "${missing_optional_models[@]}"; do
        echo "  - $model"
    done
    print_instructions "To enable image generation capabilities:
1. Log into AWS Console
2. Navigate to Amazon Bedrock
3. Request access to the missing models
4. Wait for approval (usually takes <24 hours)

These models are only needed if you want to generate item images yourself."
fi

echo -e "\n${GREEN}All required dependencies are satisfied!${NC}"
echo -e "${YELLOW}Note: Optional models are only needed if you want to generate item images yourself.${NC}" 