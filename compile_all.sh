#!/bin/bash
mkdir artifacts
set -e

tondev sol compile ./contracts/tokens/art/ArtRoot.sol
mv ArtRoot.tvc ./artifacts/
mv ArtRoot.abi.json ./artifacts/

tondev sol compile ./contracts/tokens/art/ArtToken.sol
mv ArtToken.tvc ./artifacts/
mv ArtToken.abi.json ./artifacts/

tondev sol compile ./contracts/tokens/art/TokenOwner.sol
mv TokenOwner.tvc ./artifacts/
mv TokenOwner.abi.json ./artifacts/
