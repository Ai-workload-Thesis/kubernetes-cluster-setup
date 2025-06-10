#!/bin/bash
# deploy.sh

set -e

echo "Starting Kubernetes cluster deployment..."

# Check if Ansible is available
if ! command -v ansible-playbook &> /dev/null; then
    echo "Installing Ansible..."
    apt update
    apt install -y ansible python3-pip
    pip3 install kubernetes
fi

# Run the playbook
echo "Running Ansible playbook..."
ansible-playbook -i inventory.ini site.yml

echo "Deployment completed!"
echo ""
echo "Access URLs:"
echo "- Harbor Registry: https://$(hostname -I | awk '{print $1}'):8443 (admin/admin)"
echo "- Admin Webapp: http://$(hostname -I | awk '{print $1}'):30000"
echo ""
echo "Useful commands:"
echo "- kubectl get pods --all-namespaces"
echo "- kubectl get services --all-namespaces"
echo "- kubectl get pv,pvc"