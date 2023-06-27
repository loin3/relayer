#!/bin/bash

KEYRING=--keyring-backend="test"
SILENT=1

redirect() {
  if [ "$SILENT" -eq 1 ]; then
    "$@" > /dev/null 2>&1
  else
    "$@"
  fi
}

BINARY=$1
CHAINID=$2
CHAINDIR=$3
RPCPORT=$4
P2PPORT=$5
PROFPORT=$6
GRPCPORT=$7
DENOM=$8
BASEDENOM=$9

if [ -z "$1" ]; then
  display_usage "[BINARY] ($BINARY|akash)"
fi

if [ -z "$2" ]; then
  display_usage "[CHAIN_ID]"
fi

if [ -z "$3" ]; then
  display_usage "[CHAIN_DIR]"
fi

if [ -z "$4" ]; then
  display_usage "[RPC_PORT]"
fi

if [ -z "$5" ]; then
  display_usage "[P2P_PORT]"
fi

if [ -z "$6" ]; then
  display_usage "[PROFILING_PORT]"
fi

if [ -z "$7" ]; then
  display_usage "[GRPC_PORT]"
fi

# Start the gaia
$BINARY --home $CHAINDIR/$CHAINID start --pruning=nothing --grpc-web.enable=false --grpc.address="0.0.0.0:$GRPCPORT" > $CHAINDIR/$CHAINID.log 2>&1 &
