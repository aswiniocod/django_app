#!/bin/bash

echo "Starting before_install script..."

# Step 1: Stop the running application service to avoid any conflicts
echo "Stopping app service..." >> /tmp/deployment.log
sudo systemctl stop app.service >> /tmp/deployment.log 2>&1

# Step 2: Update system packages (optional)
echo "Updating system packages..." >> /tmp/deployment.log
sudo apt-get update -y >> /tmp/deployment.log 2>&1
sudo apt-get upgrade -y >> /tmp/deployment.log 2>&1

# Step 3: Install necessary system dependencies (if not installed already)
echo "Installing system dependencies..." >> /tmp/deployment.log
sudo apt-get install -y python3-pip python3-dev python3-venv >> /tmp/deployment.log 2>&1

# Step 4: Create the virtual environment (if not already created)
if [ ! -d "/home/ubuntu/django_app/venv" ]; then
    echo "Creating virtual environment..." >> /tmp/deployment.log
    python3 -m venv /home/ubuntu/django_app/venv >> /tmp/deployment.log 2>&1
else
    echo "Virtual environment already exists. Skipping creation." >> /tmp/deployment.log
fi

# Step 5: Activate the virtual environment
echo "Activating virtual environment..." >> /tmp/deployment.log
source /home/ubuntu/django_app/venv/bin/activate

# Step 6: Upgrade pip to the latest version
echo "Upgrading pip..." >> /tmp/deployment.log
pip install --upgrade pip >> /tmp/deployment.log 2>&1

# Step 7: Install the dependencies from the requirements file
echo "Installing dependencies from requirements.txt..." >> /tmp/deployment.log
pip install -r /home/ubuntu/django_app/requirements.txt >> /tmp/deployment.log 2>&1

# Step 8: Apply database migrations
echo "Running Django migrations..." >> /tmp/deployment.log
python /home/ubuntu/django_app/manage.py migrate >> /tmp/deployment.log 2>&1

echo "Completed before_install script" >> /tmp/deployment.log