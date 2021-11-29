import asyncio
import os

from utils import send_tons_with_multisig, client
from contracts import TokenOwnerContract


async def main():
    token_owner_contract = TokenOwnerContract()

    # init object
    await token_owner_contract.create(
        './artifacts',
        'TokenOwner',
        client=client,
    )

    # send tons
    await send_tons_with_multisig(
        await token_owner_contract.address(),
        10 ** 9,
        os.path.join(os.path.dirname(__file__), '../artifacts')
    )

    # deploy
    await token_owner_contract.deploy()


if __name__ == '__main__':
    asyncio.run(main())
