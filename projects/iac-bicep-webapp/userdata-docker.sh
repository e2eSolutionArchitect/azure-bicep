#!/bin/bash
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg


sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo docker pull httpd:latest

# create a custom page for website
mkdir website
cd website
echo "<html><center> This website was created by GK and this is version 1 <br> Below is the container instance detail <br> Hostname <b> $(hostname -f)</b> <br> Host IP:<b> $(hostname -I)</b> </center><html>" > index.html
sudo docker run -d --name e2esa-web-app -p 80:80 -v ${PWD}:/usr/local/apache2/htdocs/ httpd:latest