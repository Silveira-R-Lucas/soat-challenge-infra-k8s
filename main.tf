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

provider "kubernetes" {
  alias = "eks"

  host                   = module.kubernetes_cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(module.kubernetes_cluster.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.kubernetes_cluster.cluster_name]
  }
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

module "order_app" {
  count                           = var.deploy_apps ? 1 : 0
  depends_on                      = [module.kubernetes_cluster]
  providers                       = { kubernetes = kubernetes.eks }
  source                          = "./microservices"
  app_name                        = "order-service"
  app_port                        = 3000
  container_image                 = "${aws_ecr_repository.services["order-service"].repository_url}:latest"
  database_url                    = data.aws_secretsmanager_secret_version.db_url.secret_string
  identify_client_function_url    = var.identify_client_function_url
  create_user_function_url        = var.create_user_function_url  
  rabbitmq_url                    = local.rabbitmq_url        
}

resource "kubernetes_service_v1" "payment_endpoint" {
  count     = var.deploy_apps ? 1 : 0
  provider  = kubernetes.eks
  metadata { name = "payment-service-lb" }
  spec {
    selector = { 
      app = "payment-service" 
    }
    port { 
      port = 80 
      target_port = 3001 
    }
    type = "LoadBalancer"
  }
}

module "payment_service" {
  count                           = var.deploy_apps ? 1 : 0
  depends_on                      = [module.kubernetes_cluster, kubernetes_service_v1.payment_endpoint]
  providers                       = { kubernetes = kubernetes.eks }
  source                          = "./microservices"
  app_name                        = "payment-service"
  app_port                        = 3001
  container_image                 = "${aws_ecr_repository.services["payment-service"].repository_url}:latest"
  mercadopago_secret              = var.mercadopago_secret
  mercadopago_notification_url = var.deploy_apps ? "http://${kubernetes_service_v1.payment_endpoint[0].status[0].load_balancer[0].ingress[0].hostname}/api/v1/payment_notification" : ""
  mercadopago_external_pos_id     = var.mercadopago_external_pos_id
  mercadopago_user_id             = var.mercadopago_user_id
  mercadopago_token               = var.mercadopago_token
  rabbitmq_url                    = local.rabbitmq_url
  database_url                    = data.aws_secretsmanager_secret_version.mongodb_url.secret_string
}

module "kitchen_app" {
  count               = var.deploy_apps ? 1 : 0
  depends_on          = [module.kubernetes_cluster]
  providers           = { kubernetes = kubernetes.eks }
  source              = "./microservices"
  app_name            = "kitchen-service"
  app_port            = 3002
  container_image     = "${aws_ecr_repository.services["kitchen-service"].repository_url}:latest"
  database_url        = data.aws_secretsmanager_secret_version.redis_url.secret_string 
  rabbitmq_url        = local.rabbitmq_url
}

locals {
  rabbitmq_url = "amqp://guest:guest@rabbitmq-service:5672"
}