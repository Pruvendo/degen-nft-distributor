import json
import PIL
from PIL import Image
import copy

path = ".//pics//"
temp_path = ".//temp//"
result_path = ".//result//"

temp_json = 'temp.json'

with open('pics.json') as file:
    content = file.read()
    all_pictures = json.loads(content)

ITERATIONS = len(all_pictures)
first_layer = all_pictures[0]["images"]

with open(temp_json, 'w') as file:
    json.dump(first_layer, file, indent=4)

result_json = []
pictures = []
with open(temp_json) as file:
    content = file.read()
    first_layer = json.loads(content)

for picture in first_layer:
    for layer in all_pictures[1]["images"]:
        image = Image.open(path + picture)
        next_layer = Image.open(path + layer).convert('RGBA')
        image.paste(next_layer, (0, 0), next_layer)
        image.save(temp_path + picture[:-4] + layer)
        pictures.append(picture[:-4] + layer)
        picture_name = picture[:-4] + layer
        picture_info = {"name": picture_name, "images": [picture, layer]}
        result_json.append(picture_info)
    with open(temp_json, 'w') as file:
        json.dump(pictures, file, indent=4)

for iteration in range(2, ITERATIONS):
    temp_pictures = []
    copy_result_json = result_json
    for i in range(len(all_pictures[iteration]["images"]) - 1):
        result_json = result_json + copy.deepcopy(copy_result_json)
    n = 0
    with open(temp_json) as file:
        content = file.read()
        first_layer = json.loads(content)
    for picture in first_layer:
        for layer in all_pictures[iteration]["images"]:
            result_json[n]["name"] = picture[9:-4] + layer
            result_json[n]["images"].append(layer)
            n += 1
            image = Image.open(temp_path + picture)
            next_layer = Image.open(path + layer).convert('RGBA')
            image.paste(next_layer, (0, 0), next_layer)
            if iteration <  ITERATIONS - 1:
                image.save(temp_path + picture[:-4] + layer)
                temp_pictures.append(picture[:-4] + layer)
            else: 
                image.save(result_path + picture[:-4] + layer)
    if iteration <  ITERATIONS - 1:
        with open(temp_json, 'w') as file:
            json.dump(temp_pictures, file, indent=4)
    else:
        continue

with open('result.json', 'w') as file:
    json.dump(result_json, file, indent=4)


