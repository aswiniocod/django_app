#!/bin/bash

echo "Starting after_install script..."

# Step 1: Activate the virtual environment (if you have one)
cd /home/ubuntu/django_app

echo "Activating virtual environment..."
source /home/ubuntu/venv/bin/activate

# Step 2: Install dependencies (if requirements.txt has changed or if you're setting it up for the first time)
echo "Installing Python dependencies..."
pip install -r /home/ubuntu/django_app/requirements.txt

# Step 3: Run database migrations
echo "Running Django database migrations..."
python manage.py migrate

# Create the superuser using python manage.py shell
#sudo echo "from django.contrib.auth.models import User; User.objects.create_superuser('aswin', 'aswin@iocod.com', 'admin@123')" | python3 manage.py shell

# Step 1: Restart the application service
echo "Restarting app service..." >> /tmp/deployment.log
sudo systemctl start app.service >> /tmp/deployment.log 2>&1
sudo systemctl restart app.service >> /tmp/deployment.log 2>&1

# Step 2: Apply database migrations after restarting the service (optional)
# echo "Running Django migrations..." >> /tmp/deployment.log
# source /home/ubuntu/django_app/venv/bin/activate
# python /home/ubuntu/django_app/manage.py migrate >> /tmp/deployment.log 2>&1

echo "Completed after_install script" >> /tmp/deployment.log