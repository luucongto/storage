#!/bin/bash
declare -A SERVERS=(
  ["validator-1"]="ec2-18-142-229-33.ap-southeast-1.compute.amazonaws.com"
  ["validator-2"]="ec2-13-213-57-231.ap-southeast-1.compute.amazonaws.com"
  ["validator-3"]="ec2-52-77-245-112.ap-southeast-1.compute.amazonaws.com"
  ["validator-4"]="ec2-3-1-5-16.ap-southeast-1.compute.amazonaws.com"
  ["validator-5"]="ec2-3-1-203-203.ap-southeast-1.compute.amazonaws.com"
  ["validator-6"]="ec2-13-251-156-82.ap-southeast-1.compute.amazonaws.com"
  ["validator-7"]="ec2-54-179-45-201.ap-southeast-1.compute.amazonaws.com"
  ["validator-8"]="ec2-47-129-37-145.ap-southeast-1.compute.amazonaws.com"
  ["validator-9"]="ec2-52-77-251-119.ap-southeast-1.compute.amazonaws.com"
  ["validator-10"]="ec2-54-255-134-23.ap-southeast-1.compute.amazonaws.com"
  ["validator-11"]="ec2-47-129-59-44.ap-southeast-1.compute.amazonaws.com"
  ["validator-12"]="ec2-3-0-20-196.ap-southeast-1.compute.amazonaws.com"
  ["validator-13"]="ec2-122-248-251-190.ap-southeast-1.compute.amazonaws.com"
  ["validator-14"]="ec2-13-213-6-71.ap-southeast-1.compute.amazonaws.com"
  ["validator-15"]="ec2-52-221-192-36.ap-southeast-1.compute.amazonaws.com"
  ["validator-16"]="ec2-13-215-203-112.ap-southeast-1.compute.amazonaws.com"
  ["validator-17"]="ec2-47-128-237-197.ap-southeast-1.compute.amazonaws.com"
  ["validator-18"]="ec2-54-251-166-168.ap-southeast-1.compute.amazonaws.com"
  ["validator-19"]="ec2-54-179-5-74.ap-southeast-1.compute.amazonaws.com"
  ["validator-20"]="ec2-18-142-238-106.ap-southeast-1.compute.amazonaws.com"
  ["validator-21"]="ec2-52-77-249-164.ap-southeast-1.compute.amazonaws.com"
)


for KEY in "${!SERVERS[@]}"; do
  SERVER=${SERVERS[$KEY]}
  CONFIG=/home/tom/.onematrix-config/localchain-${KEY#validator-}
  echo "Syncing to ${KEY}..."
  echo "  Server: ${SERVER}"
  echo "  Config: ${CONFIG}"
  ssh ubuntu@${SERVER} "rm -rf /home/ubuntu/.onematrix"
  rsync -rav testnode-setup.sh ubuntu@${SERVER}:/home/ubuntu/
  rsync -rav ${CONFIG}/.onematrix ubuntu@${SERVER}:/home/ubuntu/
  #rsync -rav onematrixd.zip ubuntu@${SERVER}:/home/ubuntu/
  ssh ubuntu@${SERVER} "cd /home/ubuntu && chmod +x testnode-setup.sh && ./testnode-setup.sh"
done