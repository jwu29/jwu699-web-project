#!/bin/bash
# ApplicationStart: start Tomcat and Apache (restart so new config is picked up).
set -euo pipefail
source /etc/jwu699-tomcat.env

systemctl enable "${TOMCAT_SERVICE}" httpd
systemctl restart "${TOMCAT_SERVICE}"
systemctl restart httpd
