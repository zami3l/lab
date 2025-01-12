#!/usr/bin/python3
# coding : utf-8

import toml

fileCategory = 'list/category.toml'

class Category():

    def __init__(self, _name, _description):

        self.name = _name
        self.description = _description

#Read file toml category
listCategory = toml.load(fileCategory)

validCategory = {}

for index in listCategory.keys():
    validCategory[index] = Category(listCategory[index]['name'], listCategory[index]['description'])