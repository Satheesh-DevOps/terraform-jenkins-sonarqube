#!/bin/bash

# Install Java
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt install openjdk-11-jdk -y
java -version

# Install Jenkins
sudo curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
sudo echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y 
sudo apt-get install jenkins -y
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo ufw allow 8080

# Install Docker
sudo apt-get update -y
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" <EOF
sudo apt-cache policy docker-ce
sudo apt install docker-ce -y
sudo usermod -aG docker jenkins
sudo systemctl start docker
sudo systemctl enable docker

sudo cat /var/lib/jenkins/secrets/initialAdminPassword