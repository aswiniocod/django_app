#!/bin/bash

# Log the start of the script for debugging
echo "Starting after_install script..." >> /tmp/deployment.log

# Step 1: Activate the virtual environment
echo "Activating virtual environment..." >> /tmp/deployment.log
source /home/ubuntu/venv/bin/activate

# Step 2: Install dependencies (if requirements.txt has changed or if you're setting it up for the first time)
echo "Installing Python dependencies..." >> /tmp/deployment.log
pip install -r /home/ubuntu/django_app/requirements.txt >> /tmp/deployment.log 2>&1
if [ $? -ne 0 ]; then
    echo "pip install failed." >> /tmp/deployment.log
    deactivate
    exit 1
fi

# Step 3: Run makemigrations (this checks for any model changes and generates migration files)
echo "Running makemigrations..." >> /tmp/deployment.log
/home/ubuntu/venv/bin/python /home/ubuntu/django_app/manage.py makemigrations >> /tmp/deployment.log 2>&1
if [ $? -ne 0 ]; then
    echo "makemigrations failed." >> /tmp/deployment.log
    deactivate
    exit 1
fi

# Step 4: Run migrate (this applies the migrations to the database)
echo "Running migrate..." >> /tmp/deployment.log
/home/ubuntu/venv/bin/python /home/ubuntu/django_app/manage.py migrate >> /tmp/deployment.log 2>&1
if [ $? -ne 0 ]; then
    echo "migrate failed." >> /tmp/deployment.log
    deactivate
    exit 1
fi

# Step 5: Optionally create a superuser if necessary
echo "Creating superuser..." >> /tmp/deployment.log
echo "from django.contrib.auth.models import User; User.objects.create_superuser('aswin', 'aswin@iocod.com', 'admin@123')" | /home/ubuntu/venv/bin/python /home/ubuntu/django_app/manage.py shell >> /tmp/deployment.log 2>&1
if [ $? -ne 0 ]; then
    echo "Superuser creation failed." >> /tmp/deployment.log
    deactivate
    exit 1
fi

# Step 6: Restart the application service (e.g., Gunicorn, systemd, etc.)
echo "Restarting app service..." >> /tmp/deployment.log
sudo systemctl restart app.service >> /tmp/deployment.log 2>&1
if [ $? -ne 0 ]; then
    echo "Failed to restart app service." >> /tmp/deployment.log
    deactivate
    exit 1
fi

# Step 7: Deactivate the virtual environment
deactivate

echo "Completed after_install script" >> /tmp/deployment.log