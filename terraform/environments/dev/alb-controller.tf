# Associate AWS Load Balancer Controller with its IAM role
resource "aws_eks_pod_identity_association" "alb_controller" {
  cluster_name    = module.eks_cluster.cluster_id
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = module.eks_iam.alb_controller_role_arn
}