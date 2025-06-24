 # Створюємо маршрутну таблицю для публічних підмереж
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id  # Прив'язуємо таблицю до нашої VPC

  tags = {
    Name = "${var.vpc_name}-public-rt"  # Тег для таблиці маршрутів
  }
}

# Додаємо маршрут для виходу в інтернет через Internet Gateway
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id  # ID таблиці маршрутів
  destination_cidr_block = "0.0.0.0/0"               # Всі IP-адреси
  gateway_id             = aws_internet_gateway.igw.id  # Вказуємо Internet Gateway як вихід
}

# Прив'язуємо таблицю маршрутів до публічних підмереж
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)  # Прив'язуємо кожну підмережу
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
