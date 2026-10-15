#!/usr/bin/env bash

# Exit on error, unset variable, or pipe failure
set -euo pipefail

###############################################################################
# Installing Tailscale from Official Repositories
###############################################################################
# This is an EXAMPLE file showing how to add third-party RPM repositories
# and install packages from them following Universal Blue/Bluefin conventions.
#
# IMPORTANT CONVENTIONS (from @ublue-os/bluefin):
# - Always clean up temporary repository files after installation
# - Use dnf5 exclusively (never dnf or yum)
# - Always use -y flag for non-interactive operations
# - Remove repo files to keep the image clean (repos don't work at runtime)
###############################################################################

### Install Tailscale from Official Repository
echo "Installing Tailscale..."
# Add the tailscale repository
sudo dnf5 -y config-manager addrepo --from-repofile https://pkgs.tailscale.com/stable/fedora/tailscale.repo
# Install Tailscale
sudo dnf5 -y install tailscale

echo "Tailscale installation complete!"
