terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.20.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.auth.token
}

data "aws_eks_cluster_auth" "auth" {
  name = module.eks.cluster_name
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = ">= 19.0.0"
  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  enable_cluster_creator_admin_permissions = true

  # Let the module create and manage the cluster SG
  create_cluster_security_group = true

  subnet_ids      = data.aws_subnets.default.ids
  vpc_id          = data.aws_vpc.default.id

  eks_managed_node_groups = {
    default = {
      desired_size = 2
      max_size     = 3
      min_size     = 1

      instance_types = ["t3.medium"]
    }
  }
}


# Automatically apply all YAML manifests in ./k8s-manifests folder
locals {
  manifests = fileset("${path.module}/k8s-manifests", "*.yaml")
}

resource "kubernetes_manifest" "resources" {
  # Create multiple K8s resources by iterating over manifest files
  # Converts list of files into a map where key and value are both the filename
  for_each = { for file in local.manifests : file => file }

  # Reads and decodes YAML manifest files from k8s-manifests directory 
  # path.module refers to directory containing this Terraform file
  manifest = yamldecode(file("${path.module}/k8s-manifests/${each.key}"))

  # Ensures cluster and namespace exist before creating resources
  depends_on = [module.eks, kubernetes_namespace.app]
}

# resource "aws_security_group" "eks_cluster_sg" {
#   name        = "eks-cluster-sg"
#   description = "Security group for EKS cluster"
#   vpc_id      = data.aws_vpc.default.id

#   ingress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }