#!/bin/bash
# AfterInstall: copy the WAR that CodeDeploy dropped in /opt/jwu699 into Tomcat's webapps.
set -euo pipefail
source /etc/jwu699-tomcat.env

# Remove the previously unpacked copy so Tomcat redeploys cleanly.
rm -rf "${TOMCAT_WEBAPPS}/jwu699-web-project"
install -m 644 /opt/jwu699/jwu699-web-project.war "${TOMCAT_WEBAPPS}/jwu699-web-project.war"
echo "Deployed WAR to ${TOMCAT_WEBAPPS}"
