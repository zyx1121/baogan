#!/bin/bash
# baogan heartbeat — silent presence check, no stdout
# 用來確認 hook 機制 alive，不會吵到 session

mkdir -p "${HOME}/.baogan" 2>/dev/null
date +%s > "${HOME}/.baogan/heartbeat" 2>/dev/null
exit 0
