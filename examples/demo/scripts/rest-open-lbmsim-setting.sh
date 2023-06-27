#!/bin/bash
# two-chainz creates two simd chains and configures the relayer to

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SIMD_DATA="$(pwd)/data"
RELAYER_DIR="$(dirname $SCRIPTDIR)"
RELAYER_CONF="$HOME/.relayer"

# Ensure simd is installed
if ! [ -x "$(which simd)" ]; then
  echo "Error: simd is not installed. Try running 'make build-gaia'" >&2
  exit 1
fi

# Display software version for testers
echo "SIMD VERSION INFO:"
simd version --long

# Ensure jq is installed
if [[ ! -x "$(which jq)" ]]; then
  echo "jq (a tool for parsing json in the command line) is required..."
  echo "https://stedolan.github.io/jq/download/"
  exit 1
fi

# Ensure user understands what will be deleted
if [[ -d $SIMD_DATA ]] && [[ ! "$1" == "skip" ]]; then
  read -p "$(basename $0) will delete \$(pwd)/data and \$HOME/.relayer folders. Do you wish to continue? (y/n): " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      exit 1
  fi
fi

# Delete data from old runs
rm -rf $SIMD_DATA &> /dev/null
rm -rf $RELAYER_CONF &> /dev/null

# Stop existing simd processes
killall simd &> /dev/null
killall gaiad &> /dev/null
killall akash &> /dev/null

set -e

chainid0=lbmsim-0
chainid1=lbmsim-1

echo "Generating gaia configurations..."
mkdir -p $SIMD_DATA && cd $SIMD_DATA && cd ../
./examples/demo/scripts/only-setting.sh simd $chainid0 ./data 26657 26656 6060 9090 1317 stake samoleans
./examples/demo/scripts/only-setting.sh simd $chainid1 ./data 26557 26556 6061 9091 1318 rice beans
