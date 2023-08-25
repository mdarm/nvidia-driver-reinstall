#!/bin/bash

# Uninstall existing NVIDIA drivers
sudo pacman -Rns nvidia-beta nvidia-utils-beta nvidia-settings-beta

# Define a function to download, build, and install a package from AUR
install_from_aur() {
    pkgname=$1
    
    # Clean the cache to ensure we're getting the latest from AUR
    rm -rf /tmp/${pkgname}_pkgbuild
    mkdir /tmp/${pkgname}_pkgbuild

    git clone https://aur.archlinux.org/${pkgname}.git /tmp/${pkgname}_pkgbuild

    # Change to the directory
    pushd /tmp/${pkgname}_pkgbuild

    # Make the package and install it
    makepkg -si --noconfirm

    # Return to the original directory
    popd

    # Clean up
    rm -rf /tmp/${pkgname}_pkgbuild
}

# Reinstall the packages from AUR
install_from_aur nvidia-utils-beta
install_from_aur nvidia-beta
