#!/bin/bash
RPC_ENDPOINT="http://ec2-18-142-229-33.ap-southeast-1.compute.amazonaws.com:26657"
for ((i=2; i<=21; i++))
do
echo $i
    onematrixd tx staking create-validator "/home/tom/.onematrix-config/localchain-$i/.onematrix/validator-$i.json" --from="validator-$i" --gas 1000000 --fees=1000000omtrx --chain-id=test_9000-1 --home "/home/tom/.onematrix-config/localchain-1/.onematrix/" --keyring-backend test -y --node "$RPC_ENDPOINT"
done
