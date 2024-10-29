#!/bin/bash

# Configure application environment variables
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

# Create CloudWatch Agent configuration
cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json << 'EOL'
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "csye6225"
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/tmp/logs/app.log",
            "log_group_name": "/webapp/app.log",
            "log_stream_name": "{instance_id}",
            "encoding": "utf-8"
          }
        ]
      }
    }
  },
  "metrics": {
    "namespace": "WebApp",
    "metrics_collected": {
      "statsd": {
        "service_address": ":8125",
        "metrics_collection_interval": 10,
        "metrics_aggregation_interval": 60
      },
      "collectd": {
        "metrics_aggregation_interval": 60
      }
    }
  }
}
EOL

# Restart the service to pick up new environment variables
systemctl restart webapp.service