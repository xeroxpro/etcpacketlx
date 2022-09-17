#!/usr/bin/bash

##
## Creates Service file based on JSON data
##

# Sample JSON file:
 {
    "service_name": "nvid_service",
    "description": "nvid_operations",
#    "package_path": "dotnet",
    "service_path": "",
#    "service_url": "localhost:6000"
# }

# get the first argument, the JSON file
args=("$@")
DATA_FILE=${args[0]}

# check if argument is passed
if [ -z "$DATA_FILE" ]; then
    echo "JSON Data file should be passed as first argument"
    exit 1
fi

# parse the json file
SERVICE_NAME=$(cat $DATA_FILE | jq '.service_name')
DESCRIPTION=$(cat $DATA_FILE | jq '.description')
PKG_PATH=$(cat $DATA_FILE | jq '.package_path')
SERVICE_PATH=$(cat $DATA_FILE | jq '.service_path')
# SERVICE_URL=$(cat $DATA_FILE | jq '.service_url')

# remove the double quotes
DESCRIPTION=${DESCRIPTION//'"'/}
SERVICE_NAME=${SERVICE_NAME//'"'/}
PKG_PATH=${PKG_PATH//'"'/}
SERVICE_PATH=${SERVICE_PATH//'"'/}
# SERVICE_URL=${SERVICE_URL//'"'/}

# check if service is active
IS_ACTIVE=$(sudo systemctl is-active $SERVICE_NAME)
if [ "$IS_ACTIVE" == "active" ]; then
    # restart the service
    echo "Service is running"
    echo "Restarting service"
    sudo systemctl restart $SERVICE_NAME
    echo "Service restarted"
else
    # create service file
    echo "Creating service file"
    sudo cat > /etc/systemd/system/${SERVICE_NAME//'"'/}.service << EOF
[Unit]
Description=$DESCRIPTION
After=network.target
[Service]
ExecStart=$PKG_PATH $SERVICE_PATH
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF
    # restart daemon, enable and start service
    echo "Reloading daemon and enabling service"
    sudo systemctl daemon-reload 
    sudo systemctl enable ${SERVICE_NAME//'.service'/} # remove the extension
    sudo systemctl start ${SERVICE_NAME//'.service'/}
    echo "Service Started"
fi

exit 0
