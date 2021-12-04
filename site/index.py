import aiosqlite

from aiohttp import web

DB_NAME = 'test.db'
routes = web.RouteTableDef()

@routes.get('/')
async def hello(request):
    async with aiosqlite.connect(DB_NAME) as db:
        cursor = await db.execute('''
        SELECT * FROM tokens
        ''')
        res = await cursor.fetchall()
    return web.Response(text=f"{res}")

app = web.Application()
app.add_routes(routes)
web.run_app(app)
