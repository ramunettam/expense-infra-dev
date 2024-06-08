variable "project_name" {
      default = "expense"
  
}

variable "environment" {
      default = "dev"
  
}

variable "zone_name" {
      type = string
      default = "nettam.online"
  
}

variable "common_tags" {
      type = map
      default = {
            project="expense"
            environment="dev"
            Terraform="true"
      }
}