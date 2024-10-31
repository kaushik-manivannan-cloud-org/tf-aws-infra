#!/bin/bash

# Configure application environment variables
cat > /opt/webapp/.env << EOL
DB_HOST=${db_host}
DB_PORT=${db_port}
DB_NAME=${db_name}
DB_USER=${db_username}
DB_PASSWORD=${db_password}
AWS_REGION=${aws_region}
S3_BUCKET_NAME=${s3_bucket_name}
EOL

# Set proper permissions
chown csye6225:csye6225 /opt/webapp/.env
chmod 600 /opt/webapp/.env

# Start/Restart CloudWatch agent with new configuration
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
systemctl restart amazon-cloudwatch-agent

# Restart the service to pick up new environment variables
systemctl restart webapp.service