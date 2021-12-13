output "eks_sa_role" {
    value = aws_iam_role.eks_pods.arn
}