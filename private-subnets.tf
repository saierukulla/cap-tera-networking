

resource "aws_subnet" "private" {
  count      = "${length(slice(local.az_names, 0,2))}"
  vpc_id     = "${aws_vpc.myvpc.id}"
  cidr_block = "${cidrsubnet(var.vpc_cidr, 8, count.index + length(local.az_names))}"
  availability_zone = "${local.az_names[count.index]}"

  tags = {
    Name = "PrivateSubnet-${count.index + 1}"
  }
}

resource "aws_instance" "nat" {
  ami           = "${var.nat_amis[var.region]}"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.public.*.id[0]}" 
  source_dest_check = false
 vpc_security_group_ids = ["${aws_security_group.my_secGP.id}"]

  tags = {
    Name = "docker-NAT"
  }
}

resource "aws_route_table" "private-rt" {
  vpc_id = "${aws_vpc.myvpc.id}"

  route {
    cidr_block        = "0.0.0.0/0"
    instance_id = "${aws_instance.nat.id}"
  }

  tags = {
    Name = "docker-PVT-RT"
  }
}

resource "aws_route_table_association" "private-rt-assocc" {
  count      = "${length(slice(local.az_names, 0,2))}"
  subnet_id      = "${aws_subnet.private.*.id[count.index]}"
  route_table_id = "${aws_route_table.private-rt.id}"
}

resource "aws_security_group" "my_secGP" {
  name        = "my_secGP"
  description = "Allow traffic for my private subnets"
  vpc_id      = "${aws_vpc.myvpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

