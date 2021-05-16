resource "aws_vpc" "main"{
    cidr_block ="10.0.0.0/16"
    tags = {
        Name ="terraform-yd"
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.0/24"
    tags = {
      "Name" = "terraform-yd-public_subnet"
    }
}

resource "aws_subnet" "private_subnet" {
      vpc_id = aws_vpc.main.id
    cidr_block = "10.0.10.0/24"
    tags = {
      "Name" = "terraform-yd-private_subnet"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = {
      "Name" = "terraform-yd-igw"
    }
}

resource "aws_eip" "nat" {
    vpc=true
    lifecycle {
      create_before_destroy=true
    }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public_subnet.id //natgateway는 퍼블릭에 있어야함.
  tags = {
    "Name" = "NAT-GW-1"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
    # #이너룰!
    # route = [ {
    # carrier_gateway_id = ""
    # cidr_block = "0.0.0.0/0"
    # destination_prefix_list_id = ""
    # egress_only_gateway_id = ""
    # gateway_id = aws_internet_gateway.igw.id
    # instance_id = ""
    # ipv6_cidr_block = ""
    # local_gateway_id = ""
    # nat_gateway_id = ""
    # network_interface_id = ""
    # transit_gateway_id = ""
    # vpc_endpoint_id = ""
    # vpc_peering_connection_id = ""
    # } ]

  tags = {
    "Name" = "terraform-yd-rt-public"
  }
}

resource "aws_route_table_association" "route-table_association_public" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
    tags = {
    "Name" = "terraform-yd-rt-private"
  }
}

resource "aws_route_table_association" "route-table_association_private" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private.id
}

#아웃룰 // 이너룰보다 확장성이 좋다.
resource "aws_route" "private_nat" {
    route_table_id = aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
}
resource "aws_route" "public" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}


resource "aws_vpc_endpoint" "s3" {
  vpc_id = aws_vpc.main.id
  service_name = "com.amazonaws.ap-northeast-2.s3"
  tags = {
    Name = "test"
  }
}