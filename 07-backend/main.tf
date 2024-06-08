module "backend" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}-${var.common_tags.component}"

  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.backend_sg_id.value]
  
  subnet_id = local.private_subnet_id
  ami = data.aws_ami.ami_info.id
  
    tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-${var.common_tags.component}"
    }
  )
}

resource "null_resource" "backend" {

      triggers = {

            instance_id=module.backend.id #this will be trigger every time instance is created
       
      }

      connection {
          type="ssh"  
          user = "ec2-user"
          password = "DevOps321"
          host = module.backend.private_ip
      }

      provisioner "file" {
            source = "${var.common_tags.Component}.sh"
            destination = "/temp/${var.common_tags.Component}.sh"
            
      }

      provisioner "remote-exec" {
    
        inline = [
          "chmod +x ${var.common_tags.Component}.sh"
          "sudo sh /temp/${var.common_tags.Component}.sh"
      
        ]
      } 
}

# stopping the server

resource "aws_ec2_instance_state" "backend" {
  instance_id = module.backend.id
  state       = "stopped"
  # when aws null resource provising is done
  depends_on = [ null_resource.backend ]
}

# takening Ami from instance
resource "aws_ami_from_instance" "backend" {
  name               = "${var.project_name}-${var.environment}-${var.common_tags.component}"
  source_instance_id = module.backend.id
  depends_on = [ aws_ec2_instance_state.backend ]
}

# deleting the instance 

resource "null_resource" "backend_delete" {

      triggers = {

            instance_id=module.backend.id #this will be trigger every time instance is created
       
      }

      connection {
          type="ssh"  
          user = "ec2-user"
          password = "DevOps321"
          host = module.backend.private_ip
      }
      
      provisioner "local-exec" {
       command= "aws ec2 terminate-instances --instance-ids ${module.backend.id}"      
      } 
      depends_on = [ aws_ami_from_instance.backend ]
}

# target group

resource "aws_lb_target_group" "backend" {
  name     = "${var.project_name}-${var.environment}-${var.common_tags.component}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc_id

    health_check {
    path                = "/health"
    port                = 8080
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_launch_template" "backend" {
  name = "${var.project_name}-${var.environment}-${var.common_tags.component}"

  image_id = aws_ami_from_instance.backend.id

  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.backend_sg_id]

  tag_specifications {
    resource_type = "${var.project_name}-${var.environment}-${var.common_tags.component}"

    tags = merge( common_tags,
         {    Name = }
      )
    
  }


}