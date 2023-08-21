#!/bin/bash

# Uninstall existing NVIDIA drivers
sudo pacman -Rns nvidia nvidia-utils

# Clean the cache to ensure we're getting the latest from AUR
rm -rf /tmp/nvidia_pkgbuild
mkdir /tmp/nvidia_pkgbuild

# Download the NVIDIA drivers from AUR
git clone https://aur.archlinux.org/nvidia.git /tmp/nvidia_pkgbuild

# Change to the directory
cd /tmp/nvidia_pkgbuild

# Make the package
makepkg -si --noconfirm

# Clean up
rm -rf /tmp/nvidia_pkgbuild
