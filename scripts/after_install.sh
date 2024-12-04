#!/bin/bash

echo "Starting after_install script..."

# Step 1: Activate the virtual environment (if you have one)
echo "Activating virtual environment..."
source /home/ubuntu/venv/bin/activate

# Step 2: Install dependencies (if requirements.txt has changed or if you're setting it up for the first time)
echo "Installing Python dependencies..."
pip install -r /home/ubuntu/django_app/requirements.txt

# Step 3: Run makemigrations
echo "Running makemigrations..." >> /tmp/deployment.log
/home/ubuntu/venv/bin/python /home/ubuntu/django_app/manage.py makemigrations >> /tmp/deployment.log 2>&1

if [ $? -ne 0 ]; then
    echo "makemigrations failed." >> /tmp/deployment.log
    deactivate
    exit 1
fi

# Step 4: Run migrate
echo "Running migrate..." >> /tmp/deployment.log
/home/ubuntu/venv/bin/python /home/ubuntu/django_app/manage.py migrate >> /tmp/deployment.log 2>&1

if [ $? -ne 0 ]; then
    echo "migrate failed." >> /tmp/deployment.log
    deactivate
    exit 1
fi

# Step 5: Create superuser using python manage.py shell
echo "Creating superuser..." >> /tmp/deployment.log
echo "from django.contrib.auth.models import User; User.objects.create_superuser('aswin', 'aswin@iocod.com', 'admin@123')" | /home/ubuntu/venv/bin/python /home/ubuntu/django_app/manage.py shell >> /tmp/deployment.log 2>&1

if [ $? -ne 0 ]; then
    echo "Superuser creation failed." >> /tmp/deployment.log
    deactivate
    exit 1
fi

# Step 6: Restart the application service
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
