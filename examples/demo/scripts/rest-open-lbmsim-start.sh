#!/bin/bash
# two-chainz creates two simd chains and configures the relayer to

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SIMD_DATA="$(pwd)/data"
RELAYER_DIR="$(dirname $SCRIPTDIR)"
RELAYER_CONF="$HOME/.relayer"

chainid0=lbmsim-0
chainid1=lbmsim-1

echo "Generating gaia configurations..."
mkdir -p $SIMD_DATA && cd $SIMD_DATA && cd ../
./examples/demo/scripts/only-start.sh simd $chainid0 ./data 26657 26656 6060 9090 stake samoleans
./examples/demo/scripts/only-start.sh simd $chainid1 ./data 26557 26556 6061 9091 rice beans

[ -f $SIMD_DATA/$chainid0.log ] && echo "$chainid0 initialized. Watch file $SIMD_DATA/$chainid0.log to see its execution."
[ -f $SIMD_DATA/$chainid1.log ] && echo "$chainid1 initialized. Watch file $SIMD_DATA/$chainid1.log to see its execution."

cd $RELAYER_DIR

echo "Building Relayer..."
make -C ../../ install

pwd

echo "Generating rly configurations..."
rly config init
rly chains add-dir configs/chains

SEED0=$(jq -r '.mnemonic' $SIMD_DATA/lbmsim-0/key_seed.json)
SEED1=$(jq -r '.mnemonic' $SIMD_DATA/lbmsim-1/key_seed.json)
COINID=438
echo "Key $(rly keys restore lbmsim-0 testkey "$SEED0" --coin-type $COINID) imported from lbmsim-0 to relayer..."
echo "Key $(rly keys restore lbmsim-1 testkey "$SEED1" --coin-type $COINID) imported from lbmsim-1 to relayer..."

rly paths add-dir configs/paths
