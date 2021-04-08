provider "aws" {
  region  = "us-west-2"
  profile = "security"
}
 
resource "aws_instance" "helloworld-tgb" {
  ami           = "ami-09dd2e08d601bff67"
  instance_type = "t2.micro"
  tags = {
    Name = "HelloWorld-TGB"
  }
}
