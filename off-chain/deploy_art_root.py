import asyncio
import os

from utils import send_tons_with_multisig, client
from contracts import ArtRootContract


async def main():
    art_root_contract = ArtRootContract()

    # init object
    await art_root_contract.create(
        './artifacts',
        'ArtRoot',
        client=client,
    )

    # send tons
    await send_tons_with_multisig(
        await art_root_contract.address(),
        10 ** 9,
        os.path.join(os.path.dirname(__file__), '../artifacts')
    )

    # deploy
    await art_root_contract.deploy(
        manager='0:' + '0' * 63 + '1',
        creation_min_value=0,
        creation_fee=0,
        name='',
        symbol='',
        token_code='',
    )


if __name__ == '__main__':
    asyncio.run(main())
