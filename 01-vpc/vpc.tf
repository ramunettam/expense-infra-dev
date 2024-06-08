module "vpc" {
       #source = "https://github.com/ramunettam/terraform-aws-vpc.git"
      source = "../../terraform-aws-vpc" 
      project_name=var.project_name
      environment=var.environment
      common_tags=var.common_tags
      public_subnet_cidrs = var.public_cidrs
      private_subnet_cidrs = var.private_cidrs
      database_subnet_cidrs=var.database_cidrs
  
}