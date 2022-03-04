provider "aws" {
 
  region   = "eu-west-1"
 
}
 
resource "aws_instance" "ec2" {
 
  ami         = "ami-080af029940804103"
  instance_type = "t2.micro"
  key_name= "aws_key"

 
  tags {
  name = "Jenkins"
  }

  # the VPC subnet
  subnets = module.vpc.public_subnets[0].id

  # the security group
  vpc_security_group_ids = [aws_security_group.jenkins-sg.id]

  # the public SSH key
  resource "aws_key_pair" "deployer" {
    key_name = "ta_attraqt"
    public_key = file("./ta_attraqt.pub")
  }
 
}
