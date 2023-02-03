# AWS Region
aws_region = "us-east-1"

# AWS User credentials profiles
aws_cred_profile = "default"


# ARN of jenkins user 
jenkins_user_arn = "JENKINS_USER_ARN"

# Default tags 
project_default_tags = {
  Environment = "Test"
  Owner       = "OwnerName"
  Project     = "DevOps_Practice_v1"
}

# Database information
db_name     = "petclinic"
db_username = "petclinic"
db_password = "petclinic"

# Kubernetes cluster configuration
instance_type           = "t3.micro"
instance_volume_size    = 8
instance_desired_amount = 1
instance_max_amount     = 3
instance_min_amount     = 1

pod_replicas = 2

container_image = "DOCKERHUB_REPOSITORY"
container_port  = 8080

application_name = "petclinic"
app_db_host      = "mysql1server"

