#
# Kubernetes manifest files
#

resource "kubectl_manifest" "app-deployment" {
  yaml_body = templatefile("kubernetes_templates/app-deployment.tftpl", { application_name = var.application_name, pod_replicas = var.pod_replicas, DB_endpoint = aws_db_instance.main_db.address, app_db_host = var.app_db_host, container_image = var.container_image, container_port = var.container_port })
  depends_on = [
    aws_eks_node_group.nodes_general
  ]
}

resource "kubectl_manifest" "public_load_balancer" {
  yaml_body = templatefile("kubernetes_templates/public-loadbalancer.tftpl", { application_name = var.application_name })
  depends_on = [
    aws_eks_node_group.nodes_general
  ]
}

resource "kubectl_manifest" "jenkins-deployment-role" {
  yaml_body = file("kubernetes_templates/rbac_jenkins_role.yaml")
  depends_on = [
    aws_eks_node_group.nodes_general
  ]
}

resource "kubectl_manifest" "jenkins-deployment-rolebinding" {
  yaml_body = file("kubernetes_templates/rbac_jenkins_rolebinding.yaml")
  provisioner "local-exec" {
    command = "eksctl create iamidentitymapping --cluster ${aws_eks_cluster.main.name} --region=${var.aws_region} --arn ${var.jenkins_user_arn} --group 'jenkins-deployment-group' --username jenkins-server"
  }
  depends_on = [
    aws_eks_node_group.nodes_general,
    kubectl_manifest.jenkins-deployment-role
  ]
}