from tonclient.client import TonClient
from tonclient.types import DecodedMessageBody, KeyPair
from .ton_contract import BasicContract

class ArtRootContract(BasicContract):
    async def create(self, base_dir: str, name: str, *args, keypair: KeyPair=None, client: TonClient, **kwargs) -> None:
        return await super().create(base_dir, name, *args, keypair=keypair, client=client, subscribe_event_messages=True, **kwargs)

    async def _process_event(self, event: DecodedMessageBody):
        pass

    async def deploy(
        self,
        manager,
        creation_min_value,
        creation_fee,
        name,
        symbol,
        token_code,
        traits_config,
    ) -> None:
        return await super().deploy(args=dict(
            manager=manager,
            creationMinValue=creation_min_value,
            creationFee=creation_fee,
            name=name,
            symbol=symbol,
            tokenCode=token_code,
            traitsConfig_=traits_config,
        ))

    async def address(self):
        return await super().address(dict(
            manager='0:' + '0' * 64,
            creationMinValue=0,
            creationFee=0,
            name='',
            symbol='',
            tokenCode='',
            traitsConfig_=[],
        ))
