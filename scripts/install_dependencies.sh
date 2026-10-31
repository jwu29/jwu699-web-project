#!/bin/bash
sudo yum install tomcat11 -y
sudo yum -y install httpd
sudo cat << EOF > /etc/httpd/conf.d/tomcat_manager.conf
<VirtualHost *:80>
  ServerAdmin root@localhost
  ServerName app.jwu699.com
  DefaultType text/html
  ProxyRequests off
  ProxyPreserveHost On
  ProxyPass / http://localhost:8080/jwu699-web-project/
  ProxyPassReverse / http://localhost:8080/jwu699-web-project/
</VirtualHost>
EOF