#!/bin/bash
# ValidateService: fail the deployment if the page isn't actually being served.
set -uo pipefail

for i in $(seq 1 30); do
  if curl -fsS http://localhost/ | grep -q "web application working"; then
    echo "App is responding on port 80"
    exit 0
  fi
  sleep 5
done

echo "ERROR: app did not respond on http://localhost/ within 150 seconds" >&2
source /etc/jwu699-tomcat.env 2>/dev/null && systemctl status "${TOMCAT_SERVICE}" --no-pager || true
exit 1
