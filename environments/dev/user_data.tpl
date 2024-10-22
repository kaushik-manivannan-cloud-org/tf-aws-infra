#!/bin/bash

# Create environment file
cat > /etc/profile.d/env.sh << 'EOL'
export DB_HOST=${db_host}
export DB_PORT=${db_port}
export DB_NAME=${db_name}
export DB_USER=${db_username}
export DB_PASSWORD=${db_password}
EOL

# Make the script executable
chmod +x /etc/profile.d/env.sh

# Source the environment variables
source /etc/profile.d/env.sh

# Optionally, restart your application service if needed
systemctl restart webapp.service