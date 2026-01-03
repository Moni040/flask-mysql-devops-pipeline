resource "aws_instance" "jenkins" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.flask_key.key_name
  security_groups = [aws_security_group.jenkins_sg.name]

  user_data = file("user-data/jenkins.sh")

  tags = {
    Name = "Jenkins-Server"
  }
}
