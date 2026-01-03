resource "aws_key_pair" "flask_key" {
  key_name   = var.key_name
  public_key = file("~/.ssh/flask-ec2-key.pub")
  tags = {
    Name = "flask-ec2-key"
  }
}
