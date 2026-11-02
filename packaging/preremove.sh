#!/bin/sh
# deb passes remove/upgrade, rpm the number of versions left (0 = uninstall)
case "$1" in
remove | purge | 0)
    if command -v systemctl >/dev/null 2>&1; then
        systemctl disable --now tacticalagent.service >/dev/null 2>&1 || true
    fi
    ;;
esac
