#!/bin/sh
set -eou

# Wait for the Bedrock flag for this network to be set.
echo "Waiting for Bedrock node to initialize..."
while [ ! -f /shared/initialized.txt ]; do
  sleep 1
done

if [ -n "${IS_CUSTOM_CHAIN+x}" ]; then
  export EXTENDED_ARG="${EXTENDED_ARG:-} --rollup.config=/chainconfig/rollup.json"
else
  export EXTENDED_ARG="${EXTENDED_ARG:-} --network=$NETWORK_NAME --rollup.load-protocol-versions=true --rollup.halt=major"
fi

# Start op-node.
exec op-node \
  --l1=$OP_NODE__RPC_ENDPOINT \
  --l2=http://op-geth:8551 \
  --rpc.addr=0.0.0.0 \
  --rpc.port=9545 \
  --l2.jwt-secret=/shared/jwt.txt \
  --l1.trustrpc \
  --l1.rpckind=$OP_NODE__RPC_TYPE \
  --l1.beacon=$OP_NODE__L1_BEACON \
  --syncmode=execution-layer \
  $EXTENDED_ARG $@
