import asyncio
import json
import sys
import time

import aiosqlite

from tonclient.types import KeyPair, DecodedMessageBody

from utils import client
from contracts import ArtRootContract


with open('config.json', 'r') as f:
    PUBKEY = json.load(f)['root_pubkey']

DB_NAME = 'test.db'


class LoggingArtRootContract(ArtRootContract):
    async def _process_event(self, event):
        if event.name == 'TokenCreated':
            await db_create(event)


async def db_create(event: DecodedMessageBody):
    print(event.value)
    async with aiosqlite.connect(DB_NAME) as db:
        await db.execute('''
            INSERT INTO tokens (id, address)
            VALUES
                (?, ?);
            ''',
            parameters=(event.value['id'], event.value['addr'])
        )
        await db.commit()
    async with aiosqlite.connect(DB_NAME) as db:
        cursor = await db.execute('''
        SELECT * FROM tokens
        ''')
        print(await cursor.fetchall())


async def main_loop():
    ar_contract = LoggingArtRootContract()
    await ar_contract.create(
        base_dir='./artifacts',
        name='ArtRoot',
        client=client,
        keypair=KeyPair(
            public=PUBKEY,
            secret='0' * 64,
        )
    )

    async with aiosqlite.connect(DB_NAME) as db:
        await db.execute('''
        CREATE TABLE IF NOT EXISTS tokens
            (id STRING PRIMARY KEY, address STRING);
        ''')
        await db.commit()

    while True:
        start_time = time.time()
        print('now: {}'.format(time.time()))

        process_art_root_events_task = asyncio.create_task(ar_contract.process_events())

        _, pending = await asyncio.wait(
            (
                process_art_root_events_task,

            ),
            timeout=1
        )
        delta = time.time() - start_time
        if not pending:
            await asyncio.sleep(1 - delta)


if __name__ == '__main__':
    asyncio.run(main_loop())
