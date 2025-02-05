#!/bin/bash 

apt update -y
apt install -y apache2

INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)


echo "<h1>Hello from $INSTANCE_ID</h1>" > /var/www/html/index.html

systemctl start apache2
systemctl enable apache2