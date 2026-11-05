#!/bin/bash
# ApplicationStop: stop services if they exist. Never fail the deployment here,
# because on the first deploy nothing is installed yet.
if [ -f /etc/jwu699-tomcat.env ]; then
  source /etc/jwu699-tomcat.env
  systemctl stop "${TOMCAT_SERVICE}" 2>/dev/null || true
fi
systemctl stop httpd 2>/dev/null || true
exit 0
