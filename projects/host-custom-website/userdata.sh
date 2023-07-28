#!/bin/bash
sudo apt-get update
sudo apt update
sudo apt install -y apache2

sudo ufw app list
sudo ufw allow 'Apache'
sudo ufw status

sudo systemctl status apache2
hostname -I

sudo chmod -R 777 /var/www/html
echo "<html><center> Hello World from <br> Hostname <b> $(hostname -f)</b> <br> Host IP:<b> $(hostname -I)</b> </center><html>" > /var/www/html/index.html

cat /var/www/html/index.html
