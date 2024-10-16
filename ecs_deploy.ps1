# Define variables
$imageTag = "hello-world-python:latest"
$ecrRepository = "hello-world-python"  # Replace with your ECR repository name
$clusterName = "test"
$serviceName = "test"
$region = "ap-south-1"  # Replace with your AWS region
$accountId = "975049994612"

# Function to log and exit on error
function Exit-WithError {
    Write-Host "Error: $($args[0])"
    exit 1
}

# Build Docker image
Write-Host "Building Docker image: $imageTag"
docker build -t $imageTag . || Exit-WithError "Docker build failed."

# Log in to Amazon ECR
Write-Host "Logging in to Amazon ECR..."
$loginCommand = & aws ecr get-login-password --region $region | 
    ForEach-Object { 
        docker login --username AWS --password-stdin "$accountId.dkr.ecr.$region.amazonaws.com" 
    } 

if (-not $loginCommand) {
    Exit-WithError "ECR login failed."
}

# Tag Docker image
$fullImageName = "$accountId.dkr.ecr.$region.amazonaws.com/$ecrRepository:${imageTag}"  # Use ${} for clarity
Write-Host "Tagging Docker image as $fullImageName"
docker tag $imageTag $fullImageName || Exit-WithError "Docker tag failed."

# Push Docker image to Amazon ECR
Write-Host "Pushing Docker image to ECR..."
docker push $fullImageName || Exit-WithError "Docker push failed."

# Update ECS service
Write-Host "Updating ECS service $serviceName in cluster $clusterName..."
& aws ecs update-service --cluster $clusterName --service $serviceName --force-new-deployment --region $region || Exit-WithError "ECS service update failed."

Write-Host "ECS service updated with the new image."
