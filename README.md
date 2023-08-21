# Arch Linux NVIDIA Driver Reinstallation on Kernel Update

This guide provides an automated solution for the issue where NVIDIA drivers break upon kernel updates in Arch Linux. The error one usually gets is

> NVIDIA-SMI has failed because it couldn't communicate with the NVIDIA driver.

By setting up a pacman hook, NVIDIA drivers are automatically reinstalled from the AUR every time the kernel updates. This solution is based on the NVIDIA's official [read me file](https://download.nvidia.com/XFree86/Linux-x86_64/510.60.02/README/commonproblems.html) of the driver, where it is stated that

> If you upgrade your kernel, then the simplest solution is to reinstall the driver.

## Prerequisites

- Ensure you have `git` and the `base-devel` group installed. You'll need these to build packages from the AUR.
  
  ```bash
  sudo pacman -S git base-devel
  ```

## Steps:

### 1. Create the NVIDIA driver reinstallation script:

1. Create a new script named `reinstall_nvidia.sh` with the following content:

    ```bash
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
    ```

2. Make the script executable:

    ```bash
    chmod +x /path/to/reinstall_nvidia.sh
    ```

### 2. Create a pacman hook:

1. Ensure the hooks directory exists:

    ```bash
    sudo mkdir -p /etc/pacman.d/hooks
    ```

2. Create a new hook named `nvidia.hook` in `/etc/pacman.d/hooks/` with the following content:

    ```ini
    [Trigger]
    Operation=Upgrade
    Type=Package
    Target=linux

    [Action]
    Description=Reinstalling NVIDIA drivers after kernel update...
    When=PostTransaction
    Exec=/path/to/reinstall_nvidia.sh
    ```

    **Note:** Replace `/path/to/` with the actual path where you saved the `reinstall_nvidia.sh` script.

## Conclusion

With this setup, every time the `linux` package (i.e., the kernel) upgrades, the hook will automatically trigger the NVIDIA driver reinstallation script once the kernel update transaction completes.

**Note:** This approach assumes you're using the standard `linux` package as your kernel. If you're using a different kernel package (like `linux-lts`), adjust the `Target` in the hook accordingly.
