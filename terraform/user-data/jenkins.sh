#!/bin/bash
apt update -y
apt install -y openjdk-17-jdk docker.io python3-pip python3-venv rsync
systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee \
/usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/ | tee \
/etc/apt/sources.list.d/jenkins.list

apt update -y
apt install -y jenkins
systemctl enable jenkins
systemctl start jenkins
sudo usermod -aG docker jenkins
sudo apt install python3.12-venv
sudo systemctl restart jenkins
