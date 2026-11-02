#!/bin/sh
# apk post-install and post-upgrade
if [ -f /etc/tacticalagent ]; then
    rc-update add tacticalagent default >/dev/null 2>&1 || true
    rc-service tacticalagent restart >/dev/null 2>&1 || true
else
    cat <<'MSG'
Tactical RMM agent installed but not enrolled yet. Enroll it with:
  tacticalagent -m install --api https://api.example.com --client-id <id> --site-id <id> --agent-type server --auth <token>
The values are in the Linux install script Tactical RMM generates under
Agents > Install Agent (apiURL, clientID, siteID, token). Then start it with:
  rc-update add tacticalagent default && rc-service tacticalagent start
MSG
fi
exit 0
