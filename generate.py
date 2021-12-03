import json
import PIL
from PIL import Image

path = ".//pics//"
temp_path = ".//temp//"
result_path = ".//result//"

temp_file = 'temp.json'

with open('pics.json') as file:
    content = file.read()
    templates = json.loads(content)

ITERATIONS = len(templates)
temp_names = templates[0]["images"]

with open(temp_file, 'w') as file:
    json.dump(temp_names, file, indent=4)

pictires = []
with open(temp_file) as file:
    content = file.read()
    temp_names = json.loads(content)
for picture in temp_names:
    for layer in templates[1]["images"]:
        image = Image.open(path + picture)
        new_layer = Image.open(path + layer)
        image.paste(new_layer, (0, 0), new_layer)
        image.save(temp_path + picture[:-4] + layer[:-4] + ".png")
        pictires.append(temp_path + picture[:-4] + layer[:-4] + ".png")
    with open(temp_file, 'w') as file:
        json.dump(pictires, file, indent=4)

for iteration in range(2, ITERATIONS):
    temp_pictires = []
    with open(temp_file) as file:
        content = file.read()
        temp_names = json.loads(content)
    for picture in temp_names:
        for layer in templates[iteration]["images"]:
            image = Image.open(picture)
            new_layer = Image.open(path + layer)
            image.paste(new_layer, (0, 0), new_layer)
            if iteration <  ITERATIONS - 1:
                image.save(picture[:-4] + layer[:-4] + ".png")
                temp_pictires.append(temp_path + picture[:-4] + layer[:-4] + ".png")
            else: 
                image.save(result_path + picture[9:-4] + layer[:-4] + ".png")
    if iteration <  ITERATIONS - 1:
        with open(temp_file, 'w') as file:
            json.dump(temp_pictires, file, indent=4)
    else:
        continue

