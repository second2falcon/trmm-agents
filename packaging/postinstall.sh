#!/bin/sh
# runs after install and upgrade, for deb and rpm
command -v systemctl >/dev/null 2>&1 || exit 0
systemctl daemon-reload >/dev/null 2>&1 || true

if [ -f /etc/tacticalagent ]; then
    systemctl enable tacticalagent.service >/dev/null 2>&1 || true
    systemctl restart tacticalagent.service >/dev/null 2>&1 || true
else
    cat <<'MSG'
Tactical RMM agent installed but not enrolled yet. Enroll it with the command
from Agents > Install Agent > Manual in Tactical RMM, for example:
  tacticalagent -m install -api https://api.example.com -client-id 1 -site-id 1 -agent-type server -auth <token>
then start it with: systemctl enable --now tacticalagent
MSG
fi
