#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo '<h1>Welcome to your Amazon Linux Web Server '"$(hostname)"' </h1>' > /var/www/html/index.html