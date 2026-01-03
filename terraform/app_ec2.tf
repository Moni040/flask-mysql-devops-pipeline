resource "aws_instance" "app" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.flask_key.key_name
  security_groups = [aws_security_group.app_sg.name]

  user_data = file("user-data/app.sh")

  tags = {
    Name = "App-Server"
  }
}
