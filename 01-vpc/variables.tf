variable "project_name" {
    default = "expense"

}
variable "environment" {
      default = "dev"
  
}

variable "common_tags" {
    type=map
    default = {
        Name="expense"
        Terraform="true"
        environment="dev"
    
    }
}

variable "public_cidrs" {
    type = list
    default = ["10.0.1.0/24","10.0.2.0/24"]
}

##private  subnet cidrs

variable "private_cidrs"{
    type=list

    default = [ "10.0.11.0/24","10.0.12.0/24"]
    }
variable "database_cidrs" {
    type = list
    default = [ "10.0.21.0/24","10.0.22.0/24" ]
  
}    