#
# EKS
#

# EKS Cluster Policy
resource "aws_iam_role" "eks_cluster" {
  name = "${var.project_default_tags.Project}_eks_cluster_policy"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

# EKS Cluster
resource "aws_eks_cluster" "main" {
  name     = "main_eks"
  role_arn = aws_iam_role.eks_cluster.arn
  version  = "1.24"
  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true
    subnet_ids = [
      aws_subnet.public_1a.id,
      aws_subnet.public_2b.id
    ]
  }
  provisioner "local-exec" {
    command = "aws eks --region ${var.aws_region} update-kubeconfig --name ${aws_eks_cluster.main.name} --kubeconfig ./cluster_kubeconfig"
  }
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_cluster_policy,
    aws_db_instance.main_db
  ]
}

# Authentication token to communicate with an EKS cluster
data "aws_eks_cluster_auth" "main" {
  name = "main_eks"
}

