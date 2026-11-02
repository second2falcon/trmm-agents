#!/bin/sh
# apk post-install and post-upgrade
if [ -f /etc/tacticalagent ]; then
    rc-update add tacticalagent default >/dev/null 2>&1 || true
    rc-service tacticalagent restart >/dev/null 2>&1 || true
else
    cat <<'MSG'
Tactical RMM agent installed but not enrolled yet. Enroll it with the command
from Agents > Install Agent > Manual in Tactical RMM, for example:
  tacticalagent -m install -api https://api.example.com -client-id 1 -site-id 1 -agent-type server -auth <token>
then start it with: rc-update add tacticalagent default && rc-service tacticalagent start
MSG
fi
exit 0
