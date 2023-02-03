# Region
variable "aws_region" {
  description = "The region in which the infrastructure will be deployed"
  default     = "default"
}

# AWS User credentials profile (administrator's profile who deploys the infrastructure)
variable "aws_cred_profile" {
  description = "Credentials profile name that is stored inside ~/.aws/credentials"
  default     = "default"
}

# ARN of a jenkins user 
variable "jenkins_user_arn" {
  description = "ARN of a jenkins user, that should have an access to the cluster to update the deployment"
  default = "default"
}

# Default tags 
variable "project_default_tags" {
  type = map(string)
  default = {
    Environment = "default"
    Owner       = "default"
    Project     = "default"
  }
}

# Database information
variable "db_name" {
  default     = "default"
  description = "Database name"
  sensitive   = true
}

variable "db_username" {
  default     = "default"
  description = "Database username"
  sensitive   = true
}

variable "db_password" {
  default     = "default"
  description = "Database password"
  sensitive   = true
}

# Kubernetes cluster configuration

variable "instance_type" {
  description = "Node instance type"
  default     = "t3.micro"
}

variable "instance_volume_size" {
  description = "Node volume size"
  default     = 8
}

variable "instance_desired_amount" {
  description = "Desired amount of nodes in the node group"
  default     = 2
}

variable "instance_max_amount" {
  description = "Maximum amount of nodes in the node group"
  default     = 2
}

variable "instance_min_amount" {
  description = "Minimum amount of nodes in the node group"
  default     = 2
}

variable "pod_replicas" {
  description = "The number of pod replicas"
  default     = 2
}

variable "container_image" {
  description = "Container image name"
  default     = "tomcat:latest"
}

variable "container_port" {
  description = "The port the container is listening on"
  default     = 8080
}

variable "application_name" {
  description = "Application name"
  default     = "tomcat-application"
}

variable "app_db_host" {
  description = "Name of DB that application uses to connect to it."
  default     = "mysql1server"
}