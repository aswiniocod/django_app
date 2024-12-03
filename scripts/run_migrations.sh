#!/bin/bash

# Navigate to the Django app directory
cd /home/ubuntu/django_app || exit 1  # Exit script if cd fails

# Activate the virtual environment
source /home/ubuntu/django_app/venv/bin/activate || exit 1  # Exit if activation fails

# Install the required dependencies from requirements.txt
pip install -r requirements.txt || exit 1  # Exit if pip install fails
echo "Requirements installed successfully"

# Run database migrations
python manage.py migrate --noinput || exit 1  # Exit if migration fails
echo "Database migration completed successfully"

# Create the superuser using python manage.py shell
echo "from django.contrib.auth.models import User; User.objects.create_superuser('aswin', 'aswin@iocod.com', 'admin@123')" | python3 manage.py shell

# Restart the app service (replace 'app.service' with your actual service name)
sudo systemctl restart app.service || exit 1  # Exit if service restart fails
echo "App service restarted successfully"
