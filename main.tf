##################################################################################
# PROVIDERS
##################################################################################

locals {
  common_tags = {
    Name = "IRONFALL"
  }
}

provider "aws" {
  region = var.aws_region
}

##################################################################################
# DATA
##################################################################################

data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = local.common_tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = local.common_tags
}

resource "aws_subnet" "subnet1" {
  cidr_block              = var.vpc_subnet1_cidr_block
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = local.common_tags
}

# ROUTING #
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = local.common_tags
}

resource "aws_route_table_association" "rta-subnet1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.rtb.id
}

# SECURITY GROUPS #
# Nginx security group
resource "aws_security_group" "instance-sg" {
  name   = "instance_sg"
  vpc_id = aws_vpc.vpc.id

  # HTTP access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

resource "aws_key_pair" "login" {
  key_name   = "login-key"
  public_key = var.public_key
}

# INSTANCES #
resource "aws_instance" "instance" {
  count                  = var.instance_count
  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.instance-sg.id]

  key_name = aws_key_pair.login.key_name

  user_data = <<EOF
#! /bin/bash

ironfall_script=$(cat <<END_HEREDOC
#! /bin/bash

ironfall_init() {
  sudo yum install -y wget screen
  cd /opt && \
  sudo wget --no-check-certificate 'https://git.ironfall.org/ua-it-army/iron-fall/-/jobs/21/artifacts/raw/dist/iron-fall-linux' && \
  sudo chmod +x /opt/iron-fall-linux
}

if [[ ! -f /opt/iron-fall-linux ]]; then
  ironfall_init
fi
if ! sudo screen -ls | grep -q ironfall; then
  sudo screen -dmS ironfall
  sudo screen -S ironfall -p 0 -X stuff 'sudo /opt/iron-fall-linux; sudo /opt/iron-fall-init.sh\n'
else
  sudo /opt/iron-fall-linux; sudo /opt/iron-fall-init.sh
fi
END_HEREDOC
)

echo "$ironfall_script" | sudo tee /opt/iron-fall-init.sh && \
sudo chmod +x /opt/iron-fall-init.sh && \
sudo /opt/iron-fall-init.sh
EOF

  tags = local.common_tags

}
