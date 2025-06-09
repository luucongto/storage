# Init Config

```bash
NUMBER_VALIDATOR=21 CHAIN_ID=test_9000-1 sh scripts/init-chain.sh
```

edit the ip of 1st node in `config.toml`

```bash
sh replace-seeds.sh
```

sync to node

```bash
SERVER=ec2-3-0-57-137.ap-southeast-1.compute.amazonaws.com
rsync -rav testnode-setup.sh ubuntu@$SERVER:/home/ubuntu/
rsync -rav onematrixd.zip ubuntu@$SERVER:/home/ubuntu/
rsync -rav /home/tom/.onematrix-config/localchain-2/.onematrix ubuntu@$SERVER:/home/ubuntu/
ssh ubuntu@$SERVER 
```

## Setup on server

create `/etc/systemd/system/onematrixd.service`

```text
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

```

Store this unit under /etc/systemd/system/onematrixd.service, then reload systemd to read this unit file with:

$ sudo systemctl daemon-reload
Start the service with:

$ sudo systemctl start onematrixd.service
And enable it during startup with:

$ sudo systemctl enable onematrixd.service
You can check the status of the service with:

$ systemctl status onematrixd.service
