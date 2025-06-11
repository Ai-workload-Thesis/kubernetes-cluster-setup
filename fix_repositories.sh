#!/bin/bash
# fix_repositories.sh - Fix Docker and Kubernetes repository issues

set -e

echo "Fixing repository configurations..."

# Clean up old GPG keys and repositories
echo "Cleaning up old configurations..."
sudo rm -f /etc/apt/sources.list.d/kubernetes.list
sudo rm -f /etc/apt/sources.list.d/docker.list
sudo apt-key del 9DC858229FC7DD38854AE2D88D81803C0EBFCD88 2>/dev/null || true
sudo apt-key del B53DC80D13EDEF05 2>/dev/null || true

# Create keyrings directory
sudo mkdir -p /etc/apt/keyrings

# Fix Docker repository
echo "Setting up Docker repository..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Fix Kubernetes repository
echo "Setting up Kubernetes repository..."
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null

# Update package lists
echo "Updating package lists..."
sudo apt update

echo "Repository fix completed successfully!"
echo "You can now run your Ansible playbook again."