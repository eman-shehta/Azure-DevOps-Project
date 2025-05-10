module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "eks-staging-cluster"
  cluster_version = "1.29"
  vpc_id          = aws_vpc.vpc.id
  subnet_ids      = [aws_subnet.pub_subnet1.id, aws_subnet.pub_subnet2.id]

  eks_managed_node_groups = { 
    staging_nodes = {
      desired_size   = 2
      max_size       = 3
      min_size       = 2

      instance_types = ["t2.small"]
      key_name       = "eman"

      tags = {
        Name    = "eks-staging"
        project = "Terraform-with-AzureDevOps"
      }
    }
  }

  tags = {
    Name    = "eks-staging"
    project = "Terraform-with-AzureDevOps"
  }
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

