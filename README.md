# trmm-agents

Builds the Tactical RMM agent from [second2falcon/rmmagent](https://github.com/second2falcon/rmmagent)
and publishes the binaries as GitHub releases, so a Tactical RMM server can hand out
self-built agents instead of the ones from Amidaware's code signing service.

## What gets built

| File | Platform |
|---|---|
| `tacticalagent-v<ver>-windows-amd64.exe`, `-windows-386.exe` | Windows, Inno Setup installer (unsigned) |
| `tacticalagent-v<ver>-linux-amd64`, `-386`, `-arm64`, `-arm` | Linux, static binary |
| `tacticalagent-v<ver>-darwin-amd64`, `-arm64` | macOS, static binary (unsigned) |
| `tacticalagent_<ver>-1_<arch>.deb` (amd64, i386, arm64, armhf) | Debian, Ubuntu and derivatives |
| `tacticalagent-<ver>-1.<arch>.rpm` (x86_64, i386, aarch64, armv7hl) | RHEL, Rocky, Fedora, openSUSE |
| `tacticalagent_<ver>-r1_<arch>.apk` (x86_64, x86, aarch64, armv7) | Alpine, unsigned: `apk add --allow-untrusted` |
| `SHA256SUMS` | checksums of all files above |

The Linux agent is built with `CGO_ENABLED=0`, so one binary runs on every distribution.
Each build starts it on Debian, Ubuntu, Rocky Linux (RHEL), Fedora, openSUSE and Alpine.

The packages install the same binary to `/usr/local/bin/tacticalagent` (where the Tactical RMM
installer and the agent's self-update expect it) and a systemd unit that only starts once the
agent is enrolled: a systemd unit in the .deb and .rpm, an OpenRC service in the .apk. After
installing, enroll it with the command from Agents, Install Agent, Manual and start it with
`systemctl enable --now tacticalagent` or `rc-update add tacticalagent default && rc-service
tacticalagent start`. Each build installs the .deb on Debian and Ubuntu, the .rpm on Rocky
Linux, Fedora and openSUSE and the .apk on Alpine. Mesh Central is not part of the
packages, it is installed by the Tactical RMM installer as before.

The release is tagged `v<ver>`, the version from `rmmagent/main.go`. Bump that version in
rmmagent when existing agents should update to a new build; rebuilding the same version
replaces the release files but agents already on that version will not reinstall.

## When it runs

- Daily, building only when the rmmagent commit differs from the one in the current release.
- On demand: Actions, *Build agents*, *Run workflow*, optionally with an rmmagent ref and *force*.

## Settings

Repository variables (Settings, Secrets and variables, Actions, Variables):

| Variable | Default | |
|---|---|---|
| `RMMAGENT_REPO` | `second2falcon/rmmagent` | repo to build |
| `RMMAGENT_REF` | `develop` | branch, tag or commit to build |

Secret `RMMAGENT_TOKEN` is only needed if the rmmagent repo is private.

## Using the builds on a server

Set this in `/rmm/api/tacticalrmm/tacticalrmm/local_settings.py` and restart the rmm service:

```python
AGENT_DOWNLOAD_URL = "https://github.com/second2falcon/trmm-agents/releases/download/v{version}/tacticalagent-v{version}-{plat}-{goarch}{ext}"
```

The fork's `install.sh` sets this for you.
