#!/bin/bash

cat > /opt/webapp/.env << EOL
DB_HOST=${db_host}
DB_PORT=${db_port}
DB_NAME=${db_name}
DB_USER=${db_username}
DB_PASSWORD=${db_password}
EOL

# Set proper permissions
chown csye6225:csye6225 /opt/webapp/.env
chmod 600 /opt/webapp/.env

# Restart the service to pick up new environment variables
systemctl restart webapp.service