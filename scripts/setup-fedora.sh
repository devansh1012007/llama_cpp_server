#!/bin/bash

# setup-fedora.sh - Prepares Fedora for Vulkan-accelerated Docker deployment

echo "Setting up Fedora for Docker and Vulkan..."

# 1. Install Docker and Docker Compose Plugin
echo "Installing Docker..."
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 2. Start and enable Docker
sudo systemctl enable --now docker

# 3. Add current user to docker group (Requires logout/login)
sudo usermod -aG docker $USER

# 4. Install Vulkan drivers for AMD and diagnostic tools
echo "Installing Vulkan drivers..."
sudo dnf install -y mesa-vulkan-drivers vulkan-tools vulkan-loader

# 5. Add user to the render group to allow hardware access to /dev/dri
sudo usermod -aG render $USER
sudo usermod -aG video $USER

echo "====================================================================="
echo "Setup complete!"
echo "Please verify Vulkan is working by running: vulkaninfo | grep deviceName"
echo "(You should see your AMD Radeon Graphics listed)"
echo "NOTE: You MUST log out and log back in (or reboot) for group changes to take effect."
echo "====================================================================="
