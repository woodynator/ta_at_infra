provider "aws" {
 
  region   = "eu-west-1"
 
}
 
resource "aws_instance" "ec2" {
 
  ami         = "ami-080af029940804103"
  instance_type = "t2.micro"
  key_name= "aws_key"

 
  tags {
 
  name = "Jenkins"

  # the VPC subnet
  subnets = module.vpc.public_subnets[0].id

  # the security group
  vpc_security_group_ids = ["${aws_security_group.example-instance.id}"]

  # the public SSH key
  key_name = "${aws_key_pair.mykeypair.key_name}"

  # role:
  iam_instance_profile = "${aws_iam_instance_profile.s3-mybucket-role-instanceprofile.name}"
 
  }
 
}

resource "aws_key_pair" "deployer" {
  key_name   = "aws_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDF54+VSzo44SwvUCy6KIlWBEF4hScpjcP7R1Ex6czkcDQ/wxncU1iHhcMXJo0Z+z3rGmF9I61m128d04cvm6RYM6hgNiA084ZvZrY5r8tJzDWmeFhd7ZMu1BKosEnMSET8F0iWxKDjJ6XovL3ouAr7nQ8Ytgkz7yCXG4e/pLlLk5Z/aXDYHe5ARUVYtU+P2tV3ccrecFXKWxSchmz/mTQqlF+3OsIn5ndCCl/PPlIEuh50fT9B3+zsz0H5n2T5ZuH+SPB33rjz/8osUjUQtpJ/VncRMgJTPsNfGaQkNgp7otnnSMWlOPEmcspHMZ1floT3BLvb3CR0fdqwbK+/cM0C+YZlrMYsV338vZeAht1Xa1GhIvg21SvNT6keoPWHf8A9GjgXFX5gkPP9Rv6oBi2Iia0ZDZSb9c6bDqzrYSoVgFBCxfqPdUi6Q+p3ckJpNw+xJmtXXTpf9SFMLWQ/jjPUDTfyky5XxcBXzdOHNY8ISN3AIpjJqF6nAZWF/PG4ytU="
}