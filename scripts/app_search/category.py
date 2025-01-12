#!/usr/bin/python3
# coding : utf-8

import toml, os

fileCategory = os.path.abspath('list/category.toml')
validCategory = {}

class Category():

    def __init__(self, _name, info):

        self.name = _name
        self.info = info

def list_category():
    
    print("List of categories :")
    for index, items in enumerate(validCategory.keys()):
        print("[{}] => {}".format(index, items))

#Read file toml category
listCategory = toml.load(fileCategory)

for items in listCategory.keys():
    validCategory[items] = Category(listCategory[items]['name'], listCategory[items]['info'])