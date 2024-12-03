#!/bin/bash

echo "Starting after_install script..."

# Step 1: Restart the application service
echo "Restarting app service..." >> /tmp/deployment.log
sudo systemctl restart app.service >> /tmp/deployment.log 2>&1

# Step 2: Apply database migrations after restarting the service (optional)
# echo "Running Django migrations..." >> /tmp/deployment.log
# source /home/ubuntu/django_app/venv/bin/activate
# python /home/ubuntu/django_app/manage.py migrate >> /tmp/deployment.log 2>&1

echo "Completed after_install script" >> /tmp/deployment.log