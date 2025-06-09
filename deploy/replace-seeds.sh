#!/bin/bash
declare -A SERVERS=(
  # ["validator-1"]="ec2-18-142-229-33.ap-southeast-1.compute.amazonaws.com"
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



PEER_HOST=ec2-18-142-229-33.ap-southeast-1.compute.amazonaws.com
ROOT=/home/tom/.onematrix-config/
# Create list of peer

#replace the seeds and persistent_peers in config.toml


# Peers config
EXISTED_HOME_DIR="$ROOT/localchain-1/.onematrix"
NODE_ID=$(onematrixd tendermint show-node-id --home $EXISTED_HOME_DIR)
LADDR_PORT=$(grep '^laddr' "$EXISTED_HOME_DIR/config/config.toml" | sed -E 's/.*:([0-9]+)".*/\1/')
PEER="${NODE_ID}@$PEER_HOST:${LADDR_PORT}"

PEERS=()
PEERS+=($PEER)
for KEY in "${!SERVERS[@]}"; do
  SERVER=${SERVERS[$KEY]}
  NODE_ID=$(onematrixd tendermint show-node-id --home $ROOT/localchain-${KEY#validator-}/.onematrix)
  LADDR_PORT=$(grep '^laddr' "$ROOT/localchain-${KEY#validator-}/.onematrix/config/config.toml" | sed -E 's/.*:([0-9]+)".*/\1/')
  PEERS+=("${NODE_ID}@${SERVER}:${LADDR_PORT}")
done

echo "PEERS: ${PEERS[@]}"
for i in $(seq 2 21); do
  HOME_DIR="$ROOT/localchain-$i/.onematrix"
  # Create seeds string from peers
  SEEDS=$(echo "${PEERS[@]}" | tr ' ' ',')
  # Update seeds
  sed -i -e "s|^seeds *= *\".*\"|seeds = \"${SEEDS}\"|" $HOME_DIR/config/config.toml

  # Update persistent_peers
  sed -i -e "s|^persistent_peers *= *\".*\"|persistent_peers = \"${SEEDS}\"|" $HOME_DIR/config/config.toml
done