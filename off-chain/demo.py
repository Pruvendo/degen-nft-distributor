import asyncio
import os
import sys

from utils import send_tons_with_multisig, client
from contracts import ArtRootContract, TokenOwnerContract


TOKEN_CODE = sys.argv[1]

async def main():
    token_owner_contract_1 = TokenOwnerContract()
    token_owner_contract_2 = TokenOwnerContract()
    art_root_contract = ArtRootContract()

    # init object
    await token_owner_contract_1.create(
        './artifacts',
        'TokenOwner',
        client=client,
    )
    await token_owner_contract_2.create(
        './artifacts',
        'TokenOwner',
        client=client,
    )
    await art_root_contract.create(
        './artifacts',
        'ArtRoot',
        client=client,
    )

    # send tons
    await send_tons_with_multisig(
        await token_owner_contract_1.address(),
        10 ** 11,
        os.path.join(os.path.dirname(__file__), '../artifacts')
    )
    await send_tons_with_multisig(
        await token_owner_contract_2.address(),
        10 ** 11,
        os.path.join(os.path.dirname(__file__), '../artifacts')
    )
    await send_tons_with_multisig(
        await art_root_contract.address(),
        10 ** 11,
        os.path.join(os.path.dirname(__file__), '../artifacts')
    )

    # deploy
    await token_owner_contract_1.deploy()
    await token_owner_contract_2.deploy()
    await art_root_contract.deploy(
        manager='0:' + '0' * 63 + '1',
        creation_min_value=0,
        creation_fee=0,
        name='',
        symbol='',
        token_code=TOKEN_CODE,
        traits_config=[2, 2]
    )

    # usage
    await token_owner_contract_1._create(
        await art_root_contract.address(),
        10 ** 9,
        [0, 1],
    )
    # await token_owner_contract_1.add_hash(token_address, 0)


if __name__ == '__main__':
    asyncio.run(main())