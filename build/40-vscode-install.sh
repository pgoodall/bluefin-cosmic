#!/usr/bin/env bash

# Exit on error, unset variable, or pipe failure
set -euo pipefail

### Checklist #################
# [x] Added to Containerfile  #
# [x] File is executable      #
#                             #
###############################

### Install Visual Studio Code from Official Repository
echo "Installing Visual Studio Code..."

# Add Visual Studio Code RPM repository
cat >/etc/yum.repos.d/vscode.repo <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
type=rpm-md
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

# Install Visual Studio Code
# (2026-10-16) Added libssl.so.3 to fix a bug with verifying sigs for extensions
dnf5 install -y code 'libssl.so.3()(64bit)'

# Clean up repo file (required - repos don't work at runtime in bootc images)
rm -f /etc/yum.repos.d/vscode.repo

echo "Visual Studio Code installed successfully"

echo "Visual Studio Code installation complete!"
