#!/bin/bash
declare -A SERVERS=(
  ["archive-1"]="ec2-18-140-50-211.ap-southeast-1.compute.amazonaws.com"
)


for KEY in "${!SERVERS[@]}"; do
  SERVER=${SERVERS[$KEY]}
  CONFIG=/home/tom/.onematrix-config/archive-node-${KEY#archive-}
  echo "Syncing to ${KEY}..."
  echo "  Server: ${SERVER}"
  echo "  Config: ${CONFIG}"
  ssh ubuntu@${SERVER} "rm -rf /home/ubuntu/.onematrix"
  rsync -rav testnode-setup.sh ubuntu@${SERVER}:/home/ubuntu/
  rsync -rav ${CONFIG}/.onematrix ubuntu@${SERVER}:/home/ubuntu/
  #rsync -rav onematrixd.zip ubuntu@${SERVER}:/home/ubuntu/
  ssh ubuntu@${SERVER} "cd /home/ubuntu && chmod +x testnode-setup.sh && ./testnode-setup.sh"
done