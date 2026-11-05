#!/bin/bash
# BeforeInstall: install Tomcat + Apache on Amazon Linux 2023 and configure the proxy.
set -euo pipefail

# Amazon Linux 2023 has no plain "tomcat" package (that was Amazon Linux 2).
# Use whichever versioned package the repos offer, newest first.
TOMCAT_PKG=""
for p in tomcat11 tomcat10 tomcat9; do
  if rpm -q "$p" >/dev/null 2>&1 || dnf -q list --available "$p" >/dev/null 2>&1; then
    TOMCAT_PKG="$p"
    break
  fi
done
if [ -z "$TOMCAT_PKG" ]; then
  echo "ERROR: no tomcat11/tomcat10/tomcat9 package available. Run: dnf list --available 'tomcat*'" >&2
  exit 1
fi
echo "Using Tomcat package: $TOMCAT_PKG"

dnf install -y "$TOMCAT_PKG" httpd

# Confirm the systemd service exists under the expected name.
if ! systemctl list-unit-files "${TOMCAT_PKG}.service" | grep -q "${TOMCAT_PKG}.service"; then
  echo "ERROR: ${TOMCAT_PKG}.service not found. Check: systemctl list-unit-files 'tomcat*'" >&2
  exit 1
fi

# Find Tomcat's webapps directory.
WEBAPPS=""
for d in "/var/lib/${TOMCAT_PKG}/webapps" "/usr/share/${TOMCAT_PKG}/webapps"; do
  if [ -d "$d" ]; then
    WEBAPPS="$d"
    break
  fi
done
if [ -z "$WEBAPPS" ]; then
  echo "ERROR: could not find webapps directory for $TOMCAT_PKG" >&2
  exit 1
fi
echo "Tomcat webapps directory: $WEBAPPS"

# Remember what we found so the other hook scripts can use it.
cat > /etc/jwu699-tomcat.env <<EOF
TOMCAT_SERVICE=${TOMCAT_PKG}
TOMCAT_WEBAPPS=${WEBAPPS}
EOF

# Apache reverse proxy: port 80 -> Tomcat on 8080.
cat > /etc/httpd/conf.d/tomcat_manager.conf <<'EOF'
<VirtualHost *:80>
  ServerAdmin root@localhost
  ServerName app.jwu699.com
  ProxyRequests off
  ProxyPreserveHost On
  ProxyPass / http://localhost:8080/jwu699-web-project/
  ProxyPassReverse / http://localhost:8080/jwu699-web-project/
</VirtualHost>
EOF

httpd -t
