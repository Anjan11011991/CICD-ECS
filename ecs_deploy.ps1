# Build Docker image
docker build --tag eye-ecr -f dashboard/Dockerfile . --no-cache 

# Log in to Amazon ECR
$env:AWS_REGION = ${{ secrets.AWS_REGION }}
$env:AWS_ACCESS_KEY_ID = ${{ secrets.AWS_ACCESS_KEY_ID }}
$env:AWS_SECRET_ACCESS_KEY = ${{ secrets.AWS_SECRET_ACCESS_KEY }}
aws ecr get-login-password --region $env:AWS_REGION | docker login --username AWS --password-stdin "$env:AWS_ACCOUNT_ID.dkr.ecr.$env:AWS_REGION.amazonaws.com"

# Tag and Push Docker image to Amazon ECR
$env:AWS_ACCOUNT_ID = ${{ secrets.AWS_ACCOUNT_ID }}
docker tag eye-ecr:mr-eye-frontend "$env:AWS_ACCOUNT_ID.dkr.ecr.$env:AWS_REGION.amazonaws.com/eye-ecr:mr-eye-frontend"
docker push "$env:AWS_ACCOUNT_ID.dkr.ecr.$env:AWS_REGION.amazonaws.com/eye-ecr:mr-eye-frontend"

# Update ECS service
aws ecs update-service `
    --cluster eye-ecs-cluster `
    --service MR-Eye-frontend-prod `
    --force-new-deployment `
    --region $env:AWS_REGION
