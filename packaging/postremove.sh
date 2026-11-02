#!/bin/sh
command -v systemctl >/dev/null 2>&1 && systemctl daemon-reload >/dev/null 2>&1
exit 0
