import asyncio
import json
import os
import sys

from utils import send_tons_with_multisig, client
from contracts import TokenOwnerContract


with open('config.json', 'r') as f:
    ART_ROOT_ADDRESS = json.load(f)['root_address']


async def main():
    token_owner_contract_1 = TokenOwnerContract()

    # init object
    await token_owner_contract_1.create(
        './artifacts',
        'TokenOwner',
        client=client,
    )

    # send tons
    await send_tons_with_multisig(
        await token_owner_contract_1.address(),
        10 ** 11,
        os.path.join(os.path.dirname(__file__), '../artifacts')
    )

    # deploy
    await token_owner_contract_1.deploy()

    # usage
    await token_owner_contract_1._create(
        ART_ROOT_ADDRESS,
        10 ** 9,
        [1, 1],
    )


if __name__ == '__main__':
    asyncio.run(main())
