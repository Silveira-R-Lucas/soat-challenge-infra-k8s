terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
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

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "soat-challenge-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

module "kubernetes_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  cluster_endpoint_public_access = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  eks_managed_node_groups = {
    main_pool = {
      instance_types = [var.node_flavor]
      min_size       = var.node_count
      max_size       = var.node_count + 1
      desired_size   = var.node_count
    }
  }
}

provider "kubernetes" {}

provider "kubernetes" {
  alias = "eks"

  host                   = module.kubernetes_cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(module.kubernetes_cluster.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.kubernetes_cluster.cluster_name]
  }
}

module "kubernetes_apps" {
  source = "./apps"

  providers = {
    kubernetes = kubernetes.eks
  }

  depends_on          = [module.kubernetes_cluster]
  rails_app_image_tag = var.rails_app_image_tag
  rails_master_key                = var.rails_master_key
  identify_client_function_url    = var.identify_client_function_url
  create_user_function_url        = var.create_user_function_url
  mercadopago_secret              = var.mercadopago_secret
  mercadopago_notification_url    = var.mercadopago_notification_url
  mercadopago_external_pos_id     = var.mercadopago_external_pos_id
  mercadopago_user_id             = var.mercadopago_user_id
  mercadopago_token               = var.mercadopago_token
}