module "vpc" {
  source = "./modules/vpc"

  vpc_name       = "all-in-one-vpc"
  vpc_cidr       = "10.0.0.0/16"
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["ap-southeast-1a", "ap-southeast-1b"]
}

module "eks" {
  source = "./modules/eks"

  vpc_id             = module.vpc.id
  cluster_name       = "all-in-one"
  subnet_ids         = module.vpc.public_subnets_ids
  kubernetes_version = "1.32"

  desired_size = 2
  max_size     = 3
  min_size     = 1
  instance_type = "t2.micro"

}
