sudo yum install -y httpd
sudo chkconfig httpd on
sudo service httpd start
sudo touch /var/www/html/index.html
sudo chmod 777 /var/www/html/index.html                                                                  
echo '<h1>Welcome to Packer</h1>' > /var/www/html/index.html
