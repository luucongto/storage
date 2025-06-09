#!/bin/bash
 
# Create the systemd service file
sudo bash -c 'cat > /etc/systemd/system/onematrixd.service' << 'EOF'
[Unit]
Description=OneMatrix Daemon Service
After=network.target

[Service]
User=ubuntu
Group=ubuntu
ExecStart=/usr/local/bin/onematrixd start --home /home/ubuntu/.onematrix --rpc.laddr tcp://0.0.0.0:26657
Restart=always
RestartSec=5
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

# 
sudo apt install zip unzip wget -y
cd /home/ubuntu && wget https://github.com/luucongto/storage/raw/refs/heads/main/onematrixd-en.zip
sudo unzip -P 8uVOXJUE4CRs8t -o onematrixd-en.zip -d /usr/local/bin/
sudo chmod +x /usr/local/bin/onematrixd
# Reload systemd to recognize the new service file
sudo systemctl daemon-reload

# Start the onematrixd service
sudo systemctl restart onematrixd.service

# Enable the service to run on boot
sudo systemctl enable onematrixd.service

# Check the status of the service
sudo systemctl status onematrixd.service