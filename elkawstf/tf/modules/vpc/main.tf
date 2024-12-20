#basic setup
resource "aws_vpc" "elastic_stack_vpc" {
  cidr_block = cidrsubnet(var.vpc_cidr, 0, 0)
  tags = {
    Name = "example-elasticsearch_vpc"
  }
}

resource "aws_internet_gateway" "elastic_stack_ig" {
  vpc_id = aws_vpc.elastic_stack_vpc.id
  tags = {
    Name = "example_elasticsearch_igw"
  }
}

resource "aws_route_table" "elastic_stack_rt" {
  vpc_id = aws_vpc.elastic_stack_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.elastic_stack_ig.id
  }
  tags = {
    Name = "example_elasticsearch_rt"
  }
}

resource "aws_main_route_table_association" "elastic_stack_rt_main" {
  vpc_id         = aws_vpc.elastic_stack_vpc.id
  route_table_id = aws_route_table.elastic_stack_rt.id
}

resource "aws_subnet" "elastic_stack_subnet" {
  for_each = {
    ap-southeast-1a = cidrsubnet(var.vpc_cidr, 8, 10),
    ap-southeast-1b = cidrsubnet(var.vpc_cidr, 8, 20)
  }
  vpc_id            = aws_vpc.elastic_stack_vpc.id
  availability_zone = each.key
  cidr_block        = each.value
  tags = {
    Name = "elasticsearch_subnet_${each.key}"
  }
}
