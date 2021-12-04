import aiohttp
import json
import os

from tonclient.types import Abi, CallSet, KeyPair, NetworkConfig,\
    Signer, ParamsOfEncodeMessage, ParamsOfProcessMessage
from tonclient.types import ClientConfig
from tonclient.client import TonClient

from contracts import MultisigContract


GIVER_ADDRESS = '0:b5e9240fc2d2f1ff8cbb1d1dee7fb7cae155e5f6320e585fcc685698994a19a5'


client = TonClient(
    config=ClientConfig(
        network=NetworkConfig(server_address='http://localhost'),
    ),
    is_async=True,
)


async def send_tons_with_se_giver(
    address: str,
    value: int,
    directory: str,
):
    giver_abi = Abi.from_path(
        path=os.path.join(directory, 'GiverV2.abi.json')
    )
    call_set = CallSet(
        function_name='sendTransaction',
        input={"dest":address, "value": value, "bounce": False},
    )
    with open(os.path.join(directory, 'GiverV2.keys.json')) as json_file:
        keys = json.load(json_file)
    encode_params = ParamsOfEncodeMessage(
        abi=giver_abi, signer=Signer.Keys(KeyPair(**keys)), address=GIVER_ADDRESS,
        call_set=call_set)
    process_params = ParamsOfProcessMessage(
        message_encode_params=encode_params, send_events=False)
    await client.processing.process_message(params=process_params)


async def send_tons_with_multisig(
    address: str,
    value: int,
    directory: str,
    file_name: str='SafeMultisigWallet'
):
    with open(os.path.join(directory, f'{file_name}.keys.json'), 'r') as json_file:
        keys = json.load(json_file)

    multisig = MultisigContract()
    await multisig.create(
        base_dir=directory,
        name='SafeMultisigWallet',
        client=client,
        keypair=KeyPair(
            public=keys['public'],
            secret=keys['secret'],
        )
    )

    await multisig.submit_transaction(
        dest=address,
        value=value,
    )
