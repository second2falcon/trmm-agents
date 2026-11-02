#!/bin/sh
# apk pre-deinstall, only runs on removal
rc-service tacticalagent stop >/dev/null 2>&1 || true
rc-update del tacticalagent default >/dev/null 2>&1 || true
exit 0
