from re import A
import aiohttp_jinja2
from aiohttp import web
import aiohttp
from aiohttp_jinja2 import template
from attr import dataclass
import jinja2
import json

json_file = 'result.json'

with open(json_file, 'r') as file:
    content = file.read()
    pictures = json.loads(content)


def setup_static_routes(app):
    app.router.add_static('/static/',
                          path='./static',
                          name='static')

async def create_app():
    app = web.Application()
    aiohttp_jinja2.setup(app, loader = jinja2.PackageLoader('folder', 'templates'))
    setup_routes(app)
    setup_static_routes(app)
    return app

class Picture():
    pass

async def index(request):
    pictures_data = []
    for picture in pictures:
        pic = Picture()
        pic.name = 'static/' + picture['name']
        pic.sold = 'NOPE'
        pic.unique_vector = [0, 0, 0]
        pic.cost = 100500
        pictures_data.append(pic)

    context = {'pictures': pictures_data}
    response = aiohttp_jinja2.render_template(
        'app.html',
        request,
        context,
    )
    return response

def setup_routes(app):
    app.router.add_route('GET', '/', index)

app = create_app()

if __name__ == '__main__':
    aiohttp.web.run_app(app)


'''def parse_json(json_file):
    with open(json_file, 'r') as file:
        content = file.read()
        picture_info = json.loads(content)
        for picture in picture_info:
            temp = picture["name"]
            source = picture["images"]'''
