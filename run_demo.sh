
#!/bin/bash
set -e

tondev se reset;
./compile_all.sh;
TOKEN_CODE=$(./tvm_linker decode --tvc artifacts/ArtToken.tvc | grep -oP 'code: \K\S+')
python3.9 ./off-chain/demo.py $TOKEN_CODE;