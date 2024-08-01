#! /bin/bash
sudo yum install httpd -y
sudo systemctl enable httpd
sudo systemctl start httpd
sudo bash -c "echo 'Hello world' > /var/www/html/index.html"
