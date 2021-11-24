#!/bin/bash
mkdir artifacts
set -e

tondev sol compile ./contracts/tokens/art/ArtRoot.sol
mv ArtRoot.tvc ./artifacts/
mv ArtRoot.abi.json ./artifacts/

tondev sol compile ./contracts/tokens/art/ArtToken.sol
mv ArtToken.tvc ./artifacts/
mv ArtToken.abi.json ./artifacts/

# cd ../not_validator
# tondev sol compile NotValidator.sol
# mv NotValidator.tvc ../../artifacts/
# mv NotValidator.abi.json ../../artifacts/

# cd ../depool
# tondev sol compile DePoolMock.sol
# mv DePoolMock.tvc ../../artifacts/
# mv DePoolMock.abi.json ../../artifacts/

# cd ..
# tondev sol compile __Calculator.sol
# mv __Calculator.tvc ../artifacts/
# mv __Calculator.abi.json ../artifacts/
