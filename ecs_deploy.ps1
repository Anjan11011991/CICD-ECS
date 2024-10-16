# Log in to Amazon ECR
$env:AWS_REGION = ${{ secrets.AWS_REGION }}
$env:AWS_ACCESS_KEY_ID = ${{ secrets.AWS_ACCESS_KEY_ID }}
$env:AWS_SECRET_ACCESS_KEY = ${{ secrets.AWS_SECRET_ACCESS_KEY }}

$loginCommand = aws ecr get-login-password --region $env:AWS_REGION
Invoke-Expression "$loginCommand | docker login --username AWS --password-stdin '$env:AWS_ACCOUNT_ID.dkr.ecr.$env:AWS_REGION.amazonaws.com'"

# Tag and Push Docker image to Amazon ECR
$env:AWS_ACCOUNT_ID = ${{ secrets.AWS_ACCOUNT_ID }}

docker tag hello-world-python:latest "$env:AWS_ACCOUNT_ID.dkr.ecr.$env:AWS_REGION.amazonaws.com/hello-world-python:latest"
docker push "$env:AWS_ACCOUNT_ID.dkr.ecr.$env:AWS_REGION.amazonaws.com/hello-world-python:latest"

# Update ECS service
aws ecs update-service `
  --cluster test `
  --service test `
  --force-new-deployment `
  --region $env:AWS_REGION
