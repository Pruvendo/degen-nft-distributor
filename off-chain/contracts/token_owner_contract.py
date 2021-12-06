from tonclient.client import TonClient
from tonclient.types import DecodedMessageBody, KeyPair
from .ton_contract import BasicContract

class TokenOwnerContract(BasicContract):
    async def create(self, base_dir: str, name: str, *args, keypair: KeyPair=None, client: TonClient, **kwargs) -> None:
        return await super().create(base_dir, name, *args, keypair=keypair, client=client, subscribe_event_messages=False, **kwargs)

    async def _process_event(self, event: DecodedMessageBody):
        raise NotImplementedError

    async def deploy(self) -> None:
        return await super().deploy()

    async def _create(self, root, value, unique_vector) -> None:
        return await super()._call_method(
            method='create',
            args={
                'root': root,
                'value': value,
                'uniqueVector': unique_vector,
            },
        )

    async def add_hash(self, token, hash) -> None:
        return await super()._call_method(
            method='',
            args={
                'token': token,
                'hash': hash,
            },
        )

    async def change_owner(self, token, owner) -> None:
        return await super()._call_method(
            method='',
            args={
                'token': token,
                'owner': owner,
            },
        )

    async def get_zero(self) -> None:
        return await super()._call_method(
            method='',
            args={},
        )

    async def address(self):
        return await super().address(dict(
            manager='0:' + '0' * 64,
            creationMinValue=0,
            creationFee=0,
            name='',
            symbol='',
            tokenCode='',
        ))
