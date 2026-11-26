#!/usr/bin/bash

set -euo pipefail

###############################################################################
# Default packages and services
###############################################################################
# This phase owns RPM and COPR installation. Packages are installed here, never
# in 10-overlay.sh, so a filesystem-overlay change cannot invalidate the
# expensive package layer above it.
#
# The default set keeps the reference image functional on first boot:
#   just  - the ujust entry point; base Fedora ships no just binary
#   gum   - interactive prompts used by the shared and custom ujust recipes
#   fzf   - ujust --choose, without a first-use Homebrew download
#   jq    - the ublue setup hooks and several recipes
#   uupd  - background update policy, from the ublue-os/packages COPR
###############################################################################

# Source helper functions
# shellcheck source=/dev/null
source /ctx/build/copr-helpers.sh

# Enable nullglob for all glob operations to prevent failures on empty matches
shopt -s nullglob

echo "::group:: Copy Custom Files"

# Add custom keyboard layout for Logitech MX Keys S
cp /ctx/custom/files/xkeyboard-config/symbols/logitech_mac /usr/share/xkeyboard-config-2/symbols/

echo "::endgroup::"

echo "::group:: Install Default Packages"

# Install a minimal package to verify the cache is working
# This ensures the DNF cache is populated for future builds
dnf5 install -y tmux just gum fzf jq zsh emacs fprintd fprintd-pam wev

echo "::endgroup::"

echo "::group:: System Configuration"

# Enable/disable systemd services
systemctl enable podman.socket
systemctl enable sshd
systemctl enable fprintd
# systemctl enable ostree-state-overlay@opt.service

# Example: systemctl mask unwanted-service

echo "::endgroup::"

echo "::group:: Install uupd"

# uupd owns the update policy. Its binary comes from the ublue-os/packages
# COPR; Common's shared layer (already overlaid) supplies /etc/uupd/config.json,
# the AC-connect udev rule and service, the post-suspend timer, and the
# ConditionACPower drop-in — so a desktop updates on schedule and a laptop
# updates once it is on AC.
copr_install_isolated "ublue-os/packages" uupd

echo "::endgroup::"

echo "::group:: Enable update services"

# Enable explicitly rather than relying on the shipped preset, matching how
# 10-overlay.sh enables the Brew and Flatpak units.
systemctl enable uupd.timer
systemctl enable uupd-resume.timer

echo "::endgroup::"

# Restore default glob behavior
shopt -u nullglob

echo "Custom build complete!"
