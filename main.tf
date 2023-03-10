locals {
  alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]     # Define a list of alphabet letters, to be used later for naming subnets. Instead of numbering in digits, it will be in letters A, B, C...
}

data "aws_availability_zones" "zone" {}

data "aws_ami" "latest_amazon_linux2" {
    owners      = ["amazon"]
    most_recent = true
    filter {
        name        = "name"
        values      = ["amzn2-ami-kernel-5.10-hvm-*"]
    }
    filter {
        name = "architecture"
        values = ["arm64"]
    }
}

/*
resource "aws_vpc" "this" {
    cidr_block                          = var.vpc_cidr
    assign_generated_ipv6_cidr_block    = true     # Automatically generate an IPv6 CIDR block for the VPC

    tags = {
        Name = "${var.env} VPC2"                   # the scheme of VPC2 see in the repo's README  
    }
}
*/

resource "aws_instance" "this" {
    ami                     = data.aws_ami.latest_amazon_linux2.id
    availability_zone       = data.aws_availability_zones.zone.names[0]
    instance_type           = var.instance_type
    vpc_security_group_ids  = [aws_security_group.this.id]
    user_data               = file("user_data.sh")

#    tags                    = merge(var.common_tags, { Name = "${var.common_tags["Environment"]} Server "})
}

#-------------------# Creating and attaching EBS volume - Disk 2 ----------------------------

resource "aws_ebs_volume" "disk2" {
    availability_zone = data.aws_availability_zones.zone.names[0]
    size = var.disk2

    depends_on = [
        aws_instance.this
    ]

    tags = {
           Name = "Disk2 - ${var.disk2}Gb"
    }

}

# attach disk 2 to EC2 instance
resource "aws_volume_attachment" "disk2" {
    device_name = "/dev/sdb"
    volume_id   = aws_ebs_volume.disk2.id
    instance_id = aws_instance.this.id
}

#-------------------# Creating and attaching EBS volume - Disk 3 ----------------------------

resource "aws_ebs_volume" "disk3" {
    availability_zone = data.aws_availability_zones.zone.names[0]
    size = var.disk3

    depends_on = [
        aws_ebs_volume.disk2,
        aws_volume_attachment.disk2
    ]

    tags = {
        Name = "Disk3 - ${var.disk3}Gb"
    }

}

# attach disk 3 to EC2 instance
resource "aws_volume_attachment" "disk3" {
    device_name = "/dev/sdc"
    volume_id   = aws_ebs_volume.disk3.id
    instance_id = aws_instance.this.id
}

#-------------------------Creating Security Group ------------------------

resource "aws_security_group" "this" {
    name      = "My Security Group"

    dynamic "ingress" {
        for_each = var.allow_ports
        content {
            from_port       = ingress.value
            to_port         = ingress.value
            protocol        = "tcp"
            cidr_blocks     = ["0.0.0.0/0"]
        }
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

#    tags                  = merge(var.common_tags, { Name = "${var.common_tags["Environment"]} Server SecurityGroup"})
}

#----------------------------------Create and attach EIP to instance--------------------------------

/*
resource "aws_eip" "my_static_ip" {
  instance  = aws_instance.this.id
  vpc       = true

#  tags      = merge(var.common_tags, { Name = "${var.common_tags["Environment"]} Server Elastic IP"})
  
  tags = {
      name = "Server Elastic IP"
      Owner ="PavelS"
      Project = "T1000"
      Region = var.region
  }
}
*/
