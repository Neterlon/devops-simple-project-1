terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
  default_tags {
    tags = var.project_default_tags
  }
}

provider "kubectl" {
  host = aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.main.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.main.name]
      command     = "aws"
    }
  load_config_file = false
  apply_retry_count = 3
}
