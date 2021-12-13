data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"

  cluster_version = var.eks_cluster_version
  cluster_name    = var.eks_cluster_name
  vpc_id          = data.aws_vpc.default.id
  subnets         = data.aws_subnet_ids.default.ids
  worker_groups = [
    {
      instance_type = "t2.large"
      asg_max_size  = 5
    }
  ]
}