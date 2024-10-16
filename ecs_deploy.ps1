# Define variables
$imageTag = "hello-world-python:latest"
$ecrRepository = "your_ecr_repository"  # Replace with your ECR repository name
$clusterName = "test"
$serviceName = "test"
$region = "your_region"  # Replace with your AWS region

# Build Docker image
docker build -t $imageTag .

# Log in to Amazon ECR
$loginCommand = & aws ecr get-login-password --region $region | 
    ForEach-Object { 
        docker login --username AWS --password-stdin "your_account_id.dkr.ecr.$region.amazonaws.com" 
    }  # Replace your_account_id with your AWS account ID

# Tag Docker image
docker tag $imageTag "$your_account_id.dkr.ecr.$region.amazonaws.com/$ecrRepository:$imageTag"

# Push Docker image to Amazon ECR
docker push "$your_account_id.dkr.ecr.$region.amazonaws.com/$ecrRepository:$imageTag"

# Update ECS service
& aws ecs update-service --cluster $clusterName --service $serviceName --force-new-deployment --region $region

Write-Host "ECS service updated with the new image."
