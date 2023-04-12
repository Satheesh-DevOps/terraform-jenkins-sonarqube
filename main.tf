# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-main"
  }

}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "vpc-main-igw"
  }
}

# Create a route table for the public subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-subnet-route-table"
  }
}

# Create a public subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "public-subnet"
  }

}

# Create a public subnet & route table association
resource "aws_route_table_association" "public_rt_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# Create a security group for jenkins server
resource "aws_security_group" "my_security_group" {
  name        = "Jenkins-Sonarqube-sg"
  vpc_id      = aws_vpc.my_vpc.id
  description = "Allow inbound & outbound traffic"

  dynamic "ingress" {
    for_each = toset(var.allowed_ports)

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    for_each = toset(var.allowed_egress_ports)

    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

# Launch an EC2 instance for jenkins
resource "aws_instance" "jenkins-server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.my_security_group.id]
  key_name                    = "jenkins-new"
  associate_public_ip_address = true

  tags = {
    Name = "Jenkins-Server"
  }
}

resource "null_resource" "jenkins" {

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("aws-keys/jenkins-new.pem")
    host        = aws_instance.jenkins-server.public_ip
  }

  provisioner "file" {
    source      = "jenkins.sh"
    destination = "/tmp/jenkins.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/jenkins.sh",
      "sudo bash /tmp/jenkins.sh",
    ]
  }
}

# Launch an EC2 instance for sonarqube
resource "aws_instance" "sonarqube-server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.my_security_group.id]
  key_name                    = "jenkins-new"
  associate_public_ip_address = true

  tags = {
    Name = "Sonarqube-Server"
  }
}

resource "null_resource" "sonarqube" {

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("aws-keys/jenkins-new.pem")
    host        = aws_instance.sonarqube-server.public_ip
  }

  provisioner "file" {
    source      = "sonarqube.sh"
    destination = "/tmp/sonarqube.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/sonarqube.sh",
      "sudo bash /tmp/sonarqube.sh",
    ]
  }
}
