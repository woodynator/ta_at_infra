resource "aws_instance" "ec2" {
 
  ami         = "ami-080af029940804103"
  instance_type = "t2.micro"

  #specify key, define below at the end
  key_name = aws_key_pair.deployer.key_name

  # specify vpc
  vpc_security_group_ids = [aws_security_group.jenkins-sg.id]

  # specify subnet (defined in vpc.tf)
  subnet_id = aws_subnet.main-public-1.id

  #this is for executing a custom script. I will use this to update and install docker and jenkins)
    user_data = file("${path.module}/startup.sh")
#   private_ip = "10.0.1.10"

  tags = {
    Name = "Jenkins"
  }

  # the VPC subnet
  # subnets = module.vpc.public_subnets[0].id


#   network_interface {
#     network_interface_id = aws_network_interface.net.id
#     device_index         = 0
#   }
 
}

# resource "aws_network_interface" "net" {
#   subnet_id = aws_subnet.main-public-1.id
#   tags = {
#     Name = "primary_network_interface"
#   }
# }

resource "aws_key_pair" "deployer" {
   key_name = "ta_attraqt"
   public_key = file("./ta_attraqt.pub")
}


terraform {
  backend "s3" {
    bucket         = "jm-tf-state"
    key            = "infrajenkins/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "jm-tf-locks-table-infrajenkins"
  }
}
 
 
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "jm-tf-locks-table-eks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}