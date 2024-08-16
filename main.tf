

#storing the remote state file in s3

terraform {
  backend "s3" {

    bucket = "demo_bucket"
    key="terraform.tfstate"
    region="eu-central-1"    
  }
}


# creating ec2 instance 

resource "aws_instance" "example" {
    ami="ami-03f0544597f43a91d"
    instance_type = "t2.micro"
    key_name = "key_for_demo"
    vpc_security_group_ids = [aws_security_group.webSg.id]


#Configuring file provisioner and ssh .

    provisioner "file"{
      source = "/home/vishnu/keys/test-provisioner.txt"
      destination = "/home/ubuntu/test-provisioner.txt"
    }
  
  connection {
    type = "ssh"
    host = self.public_ip
    user = "ubuntu"
    private_key = file("/home/vishnu/keys/key_for_demo")
    timeout = "4m"
  }
}

#Security group for the ec2 instance

resource "aws_security_group" "webSg" {

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

 
}

#public key for the ec2 instance 

resource "aws_key_pair" "test-key" {
key_name = "key_for_demo"
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpjMxcEUAqpLzGZPtC6c8mglFo216rPEi04l40T2fgKvKUKe0CmMV59xAu+BxNTLYrYGyBx8xwSWtjsYT4ZDg7xFvgquQdvQWQ7x0O664odza1uuqnOszSjiU7QFfYJe1VgyPCco074cfLEvZD9NEQkAFbpg/He+3PnUNV1CsZ3uuzkyB6S/EuM+R3SYAH7nJhpu77NcaWclcEIwGBhHDVhPgYQ70LjqkGc7yFa95AfnUtiyko74ybDlF93DbifZx4Yndn/g0L1ASx6DBJQSfRvl0KLnUUc5kojQEERkWJnGKMiZN8E4lD6hjVILleSPcmREi8dUXcZB5f4Nd0cwJl vishnu@fury"
}