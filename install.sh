#!/bin/bash

set -e

VERSION="v0.1.0"
ARCH=$(uname -m)

if [[ "$ARCH" == "aarch64" ]]; then
    echo "ARM64 architecture detected."
else
    echo "Unsupported architecture!"
fi

echo "Fetching binary..."
wget https://github.com/lbecher/my-box-ip-client/releases/download/$VERSION/my-box-ip-client-$ARCH -O my-box-ip-client

echo "Copying binary..."
sudo cp my-box-ip-client /usr/local/bin/my-box-ip-client
sudo chmod +x /usr/local/bin/my-box-ip-client

echo "Creating service..."
SERVICE_FILE="/etc/systemd/system/my-box-ip-client.service"
sudo tee "$SERVICE_FILE" > /dev/null <<EOF
[Unit]
Description=My Box IP Client

[Service]
Type=oneshot
Environment=SERVER_ADDR=\${SERVER_ADDR}
ExecStart=/usr/local/bin/my-box-ip-client
EOF

echo "Creating timer..."
TIMER_FILE="/etc/systemd/system/my-box-ip-client.timer"
sudo tee "$TIMER_FILE" > /dev/null <<EOF
[Unit]
Description=Runs My Box IP Client every 5 minutes

[Timer]
OnBootSec=5min
OnUnitActiveSec=5min
Unit=my-box-ip-client.service

[Install]
WantedBy=timers.target
EOF

echo "Enabling timer..."
sudo systemctl daemon-reload
sudo systemctl enable my-box-ip-client.timer
sudo systemctl start my-box-ip-client.timer

echo "Done!"
