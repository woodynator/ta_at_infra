resource "aws_instance" "ec2" {
 
  # Selected AMI is the AWS Linux AMI. ID is for eu-west-1 region
  ami         = "ami-080af029940804103"
  instance_type = "t2.small"

  # specify key. defined below
  key_name = aws_key_pair.deployer.key_name

  # specify vpc
  vpc_security_group_ids = [aws_security_group.jenkins-sg.id]

  # specify subnet (defined in vpc.tf)
  subnet_id = aws_subnet.main-public-1.id

  #this is for executing a custom script. I will use this to update and install docker and jenkins)
    user_data = file("${path.module}/startup.sh")
  
  # (optional) I set the private IP here, MUST be on the VPC PUBLIC SUBNET range 
  private_ip = "10.0.1.10"

  tags = {
    Name = "Jenkins"
  }

}

# Since access with key is default, a pre-created keypair is used. 

resource "aws_key_pair" "deployer" {
   key_name = "ta_at"
   public_key = file("./ta_at.pub")
}

# this block creates the S3 bucket that will be used by terraform for remote tf states. 

# resource "aws_s3_bucket" "bucket" {
#     bucket = "jm-tf-state"
#     acl = "private"   
# }


# terraform {
#   backend "s3" {
#     bucket         = "jm-tf-state"
#     key            = "infrajenkins/terraform.tfstate"
#     region         = "eu-west-1"
#     dynamodb_table = "jm-tf-locks-table-infrajenkins"
#   }
# }
 
# this block creates the DynamoDB table that will be used by terraform for remote tf states. 

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "jm-tf-locks-table-eks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}