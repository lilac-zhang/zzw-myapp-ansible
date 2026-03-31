provider "aws" {
  region = "ap-northeast-1"
}

# セキュリティーグループ（22, 80，5000）
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "allow ssh and http"
  vpc_id      = "vpc-06992be4b24818bd1"   

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    description = "Flask"
    from_port   = 5000
    to_port     = 5000
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

# EC2
resource "aws_instance" "web" {
  ami           = "ami-088b486f20fab3f0e" 
  instance_type = "t3.micro"

  subnet_id = "subnet-0c93a6762611fc349"   

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  key_name = "222"

  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              
              yum install -y git python3-pip
              cd /home/ec2-user
              git clone --depth=1 --filter=blob:none --sparse https://github.com/lilac-zhang/zzw-myapp0326.git
              cd zzw-myapp0326

              git sparse-checkout set my_app0326_python
              cd my_app0326_python
              python3 -m venv venv
              venv/bin/pip install flask requests
              nohup venv/bin/python app.py > app.log 2>&1 &
             
              EOF

  tags = {
    Name = "zzw-ec2"
  }
}