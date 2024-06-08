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
        Environment="dev"
        Component="backend"
    
    }
}

variable "zone_name" {
    default = "nettam.online"
  
}