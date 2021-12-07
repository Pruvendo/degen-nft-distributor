from flask import Flask, render_template
import aiohttp_jinja2
from aiohttp import web
import aiohttp
from aiohttp_jinja2 import template
import jinja2
import json

json_file = 'result.json'

with open(json_file, 'r') as file:
    content = file.read()
    pictures = json.loads(content)


async def create_app():
    app = web.Application()
    aiohttp_jinja2.setup(app, loader = jinja2.PackageLoader('folder', 'templates'))
    setup_routes(app)
    return app

@template('app.html')
async def index(request):
    return {"pictures": pictures}

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
