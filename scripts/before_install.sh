#!/bin/bash

echo "Starting before_install script..."

# Step 1: Stop the running application service to avoid any conflicts
echo "Stopping app service..." >> /tmp/deployment.log
sudo systemctl stop app.service >> /tmp/deployment.log 2>&1

# Remove the entire .git directory to avoid conflicts during deployment
rm -rf /home/ubuntu/django_app/.git

# Ensure the destination directory is clean
rm -rf /home/ubuntu/django_app/*
