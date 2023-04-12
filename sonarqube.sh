# Install Docker
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" <EOF
sudo apt-cache policy docker-ce
sudo apt install docker-ce -y
sudo systemctl start docker
sudo systemctl enable docker

# INSTALL SONARQUBE
docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube