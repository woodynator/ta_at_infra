resource "aws_instance" "ec2" {
 
  ami         = "ami-080af029940804103"
  instance_type = "t2.micro"
  key_name = aws_key_pair.deployer.key_name

  tags = {
    name = "Jenkins"
  }

  # the VPC subnet
  # subnets = module.vpc.public_subnets[0].id

  # the security group
  vpc_security_group_ids = [aws_security_group.jenkins-sg.id]

  # the public SSH key

  network_interface {
    network_interface_id = aws_network_interface.net.id
    device_index         = 0
  }
 
}

resource "aws_network_interface" "net" {
  subnet_id = aws_subnet.main-public-1.id

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_key_pair" "deployer" {
   key_name = "ta_attraqt"
   public_key = file("./ta_attraqt.pub")
}